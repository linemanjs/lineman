extend = require('config-extend')
grunt = require('grunt')
path = require('path')
_ = grunt.util._
findsPluginModules = require('./finds-plugin-modules')

module.exports =

  default: ->
    extend true, {},
      application: require("./../config/application")
      files: require("./../config/files")

  withPlugins: ->
    _(@default()).tap (config) ->
      _(pluginFiles()).each (pluginPath) ->
        plugin = requirePlugin(pluginPath, config)
        overrideAppConfig(plugin, config.application, pluginPath)
        overrideFilesConfig(plugin, config.files)

  # the user override configs will start with @withPlugins.
  withUserOverrides: ->
    extend true, {},
      require("#{process.cwd()}/config/application"),
      files: require("#{process.cwd()}/config/files")

pluginFiles = ->
  grunt.file.expand(pluginFilesFromLinemanCore().concat(pluginModulesFromNpm(), pluginFilesFromUserProject()))

pluginFilesFromLinemanCore = ->
  ["#{__dirname}/../config/plugins/**/*"]

pluginModulesFromNpm = ->
  moduleNames = findsPluginModules.find().map (pluginModule) ->
    "#{process.cwd()}/node_modules/#{pluginModule}/config/plugins/**/*"

pluginFilesFromUserProject = ->
  ["#{process.cwd()}/config/plugins/**/*"]

requirePlugin = (path, config) ->
  plugin = require(path)
  plugin?(linemanWithPluginConfigSoFar(config)) || plugin

linemanWithPluginConfigSoFar = (config) ->
  _(require('./../lineman')).tap (lineman) ->
    lineman.config.application = config.application
    lineman.config.files = config.files

overrideAppConfig = (plugin, appConfig, pluginPath) ->
  extend(true, appConfig, plugin.config) if plugin.config?

overrideFilesConfig = (plugin, filesConfig) ->
  extend(true, filesConfig, plugin.files) if plugin.files?

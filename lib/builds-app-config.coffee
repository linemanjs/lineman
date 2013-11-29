extend = require('config-extend')
grunt = require('grunt')
path = require('path')
_ = grunt.util._

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

  withUserOverrides: ->
    extend true, {},
      require("#{process.cwd()}/config/application"),
      files: require("#{process.cwd()}/config/files")

pluginFiles = ->
  grunt.file.expand([
    "#{__dirname}/../config/plugins/**/*",
    "#{process.cwd()}/config/plugins/**/*",
  ])

requirePlugin = (path, config) ->
  plugin = require(path)
  plugin?(linemanWithPluginConfigSoFar(config)) || plugin

linemanWithPluginConfigSoFar = (config) ->
  _(require('./../lineman')).tap (lineman) ->
    lineman.config.application = config.application
    lineman.config.files = config.files

overrideAppConfig = (plugin, appConfig, pluginPath) ->
  appConfigName = appConfigNameForPlugin(pluginPath, plugin)
  if plugin.config?
    appConfig[appConfigName] ||= {}
    extend(true, appConfig[appConfigName], plugin.config)

appConfigNameForPlugin = (pluginPath, plugin) ->
  return plugin.name if plugin.name?
  _.str.camelize(path.basename(pluginPath).split('.')[0])

overrideFilesConfig = (plugin, filesConfig) ->
  return unless plugin.files?
  extend(true, filesConfig, plugin.files)

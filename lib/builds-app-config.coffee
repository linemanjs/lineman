extend = require('config-extend')
grunt = require('./requires-grunt').require()
path = require('path')
_ = require("lodash")
findsPluginModules = require('./finds-plugin-modules')

module.exports =

  default: _.memoize ->
    freshExtend
      application: require("./../config/application")
      files: require("./../config/files")

  withPlugins: _.memoize ->
    extendTap @default(), (config) ->
      _.each pluginFiles(), (pluginPath) ->
        plugin = requirePlugin(pluginPath, config)
        overrideAppConfig(plugin?.config, config)
        overrideFilesConfig(plugin?.files, config)

  withUserOverrides: _.memoize ->
    extendTap @withPlugins(), (config) =>
      overrideAppConfig(loadUserOverride("application", config), config)
      overrideFilesConfig(loadUserOverride("files", config), config)

  forGrunt: ->
    conf = @withUserOverrides()
    freshExtend(conf.application, files: conf.files)

freshExtend = (extensions...) ->
  extend(true, {}, extensions...)

extendTap = (object, tapper) ->
  config = freshExtend(object)
  tapper(config)
  config

pluginFiles = ->
  grunt.file.expand(pluginFilesFromLinemanCore().concat(pluginModulesFromNpm(), pluginFilesFromUserProject()))

pluginFilesFromLinemanCore = ->
  ["#{__dirname}/../config/plugins/**/*"]

pluginModulesFromNpm = ->
  moduleNames = findsPluginModules.find().map (pluginModule) ->
    "#{pluginModule.dir}/config/plugins/**/*"

pluginFilesFromUserProject = ->
  ["#{process.cwd()}/config/plugins/**/*"]

requirePlugin = (path, config) ->
  plugin = require(path)
  plugin?(linemanWithPluginConfigSoFar(config)) || plugin

loadUserOverride = (name, config) ->
  requirePlugin("#{process.cwd()}/config/#{name}", config)

linemanWithPluginConfigSoFar = (config) ->
  _.tap require('./../lineman'), (lineman) ->
    lineman.config.application = config.application
    lineman.config.files = config.files

overrideAppConfig = (pluginConfig, config) ->
  extend(true, config.application, pluginConfig) if pluginConfig?

overrideFilesConfig = (pluginFiles, config) ->
  extend(true, config.files, pluginFiles) if pluginFiles?


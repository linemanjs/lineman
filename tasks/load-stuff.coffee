fs = require('fs')
hooks = require('./../lib/hooks')
findsPluginModules = require('./../lib/finds-plugin-modules')
buildsAppConfig = require('./../lib/builds-app-config')
resolvesQuietly = require('./../lib/resolves-quietly')
_ = require("lodash")

module.exports = (grunt) ->
  config = buildsAppConfig.forGrunt()
  pluginModules = findsPluginModules.find()

  linemanNpmTasks = [
    "grunt-contrib-clean"
    "grunt-contrib-coffee"
    "grunt-concat-sourcemap"
    "grunt-contrib-copy"
    "grunt-contrib-handlebars"
    "grunt-contrib-jshint"
    "grunt-contrib-jst"
    "grunt-contrib-cssmin"
    "grunt-contrib-uglify"
    config.watch.options.module
  ]

  loadTask = (module) ->
    if fs.existsSync("#{process.cwd()}/node_modules/#{module}")
      grunt.loadNpmTasks(module)
    else if path = otherTaskPathsFor(module)
      grunt.loadTasks("#{path}/tasks")
    else
      grunt.log.error("Task module #{module} not found")

  otherTaskPathsFor = (taskModule) ->
    _(pluginTaskModuleLocations(taskModule)).find(fs.existsSync) || resolvesQuietly.resolve(taskModule, basedir: "#{__dirname}/../")

  pluginTaskModuleLocations = (taskModule) ->
    _(pluginModules).chain()
      .map (pluginModule) ->
        resolvesQuietly.resolve(taskModule, basedir: pluginModule.dir)
      .compact()
      .value()

  npmTasks = _(linemanNpmTasks).chain().
    union("grunt-contrib-sass" if config.enableSass).
    union("grunt-asset-fingerprint" if config.enableAssetFingerprint).
    union(config.loadNpmTasks).
    compact().value()

  _(npmTasks).each (taskName) ->
    loadTask(taskName)
    hooks.trigger("loadNpmTasks.afterLoad.#{taskName}", "afterLoad", taskName)

fs = require('fs')
hooks = require('./../lib/hooks')
findsPluginModules = require('./../lib/finds-plugin-modules')
_ = require("underscore")
config = require("#{process.cwd()}/config/application")

module.exports = (grunt) ->

  linemanNpmTasks = [
    "grunt-contrib-clean"
    "grunt-contrib-coffee"
    "grunt-contrib-concat"
    "grunt-contrib-handlebars"
    "grunt-contrib-jshint"
    "grunt-contrib-jst"
    "grunt-contrib-less"
    "grunt-contrib-cssmin"
    "grunt-contrib-uglify"
    "grunt-watch-nospawn"
  ]

  loadTask = (module) ->
    if fs.existsSync("#{process.cwd()}/node_modules/#{module}")
      grunt.loadNpmTasks(module)
    else if modulePath = otherTaskModuleLocation(module)
      grunt.loadTasks(modulePath)
    else
      grunt.log.error("Task module #{module} not found")

  otherTaskModuleLocation = (taskModule) ->
    _(pluginTaskModuleLocations(taskModule).concat("#{__dirname}/../node_modules/#{taskModule}/tasks")).
      find(fs.existsSync)

  pluginTaskModuleLocations = (taskModule) ->
    _(findsPluginModules.find()).map (pluginModule) ->
      "#{process.cwd()}/node_modules/#{pluginModule}/node_modules/#{taskModule}/tasks"

  npmTasks = _(linemanNpmTasks).chain().
    union("grunt-contrib-sass" if config.enableSass).
    union("grunt-asset-fingerprint" if config.enableAssetFingerprint).
    union(config.loadNpmTasks).
    compact().value()

  _(npmTasks).each (taskName) ->
    loadTask(taskName)
    hooks.trigger("loadNpmTasks.afterLoad.#{taskName}", "afterLoad", taskName)

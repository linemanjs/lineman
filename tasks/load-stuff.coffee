fs = require('fs')
hooks = require('./../lib/hooks')

module.exports = (grunt) ->
  _ = grunt.util._

  config = require("#{process.cwd()}/config/application")
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
    else
      grunt.loadTasks("#{__dirname}/../node_modules/#{module}/tasks")

  npmTasks = grunt.util._(linemanNpmTasks).chain().
    union("grunt-contrib-sass" if config.enableSass).
    union("grunt-asset-fingerprint" if config.enableAssetFingerprint).
    union(config.loadNpmTasks).
    compact().value()

  _(npmTasks).each (taskName) ->
    loadTask(taskName)
    hooks.trigger("loadNpmTasks.afterLoad.#{taskName}", "afterLoad", taskName)

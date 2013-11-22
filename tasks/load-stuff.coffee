fs = require('fs')

module.exports = (grunt) ->
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
    "grunt-asset-fingerprint"
  ]

  loadTask = (module) ->
    if fs.existsSync("#{process.cwd()}/node_modules/#{module}")
      grunt.loadNpmTasks(module)
    else
      grunt.loadTasks("#{__dirname}/../node_modules/#{module}/tasks")

  npmTasks = grunt.util._(linemanNpmTasks).chain().
    union("grunt-contrib-sass" if config.enableSass).
    union(config.loadNpmTasks).
    compact().value()

  loadTask task for task in npmTasks

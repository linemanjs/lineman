fs = require('fs')

module.exports = (grunt) ->
  config = require("#{process.cwd()}/config/application")

  linemanNpmTasks = [
    "grunt-contrib-clean"
    "grunt-contrib-coffee"
    "grunt-contrib-concat"
    "grunt-contrib-copy"
    "grunt-contrib-handlebars"
    "grunt-contrib-jshint"
    "grunt-contrib-jst"
    "grunt-contrib-less"
    "grunt-contrib-cssmin"
    "grunt-contrib-uglify"
    "grunt-contrib-watch"
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

  grunt.renameTask "copy", "images"

  # must load again after a rename
  loadTask "grunt-contrib-copy"
  grunt.renameTask "copy", "webfonts"

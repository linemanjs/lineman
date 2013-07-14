fs = require('fs')

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
  "grunt-watch-nospawn"
]

module.exports = (grunt) ->
  config = require("#{process.cwd()}/config/application")

  loadTask = (module) ->
    if fs.existsSync("#{process.cwd()}/node_modules/#{module}")
      grunt.loadNpmTasks(module)
    else
      grunt.loadTasks("#{__dirname}/../node_modules/#{module}/tasks")

  loadTask module for module in grunt.util._.chain(linemanNpmTasks).
    union("grunt-contrib-sass" if config.enableSass).
    union(config.loadNpmTasks).compact().value()

  grunt.task.renameTask("copy", "images")

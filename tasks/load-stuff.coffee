fs = require('fs')

module.exports = (grunt) ->
  loadNpmTasks = require("#{process.cwd()}/config/application").loadNpmTasks || []
  linemanNpmTasks = [
    "grunt-contrib-clean",
    "grunt-contrib-coffee",
    "grunt-contrib-concat",
    "grunt-contrib-handlebars",
    "grunt-contrib-jshint",
    "grunt-contrib-jst",
    "grunt-contrib-less",
    "grunt-sass",
    "grunt-contrib-cssmin",
    "grunt-contrib-uglify",
    "grunt-watch-nospawn"
  ]

  grunt.util._(linemanNpmTasks).
    chain().
    union(loadNpmTasks).
    each (module) ->
      if fs.existsSync("#{process.cwd()}/node_modules/#{module}")
        grunt.loadNpmTasks(module)
      else
        grunt.loadTasks("#{__dirname}/../node_modules/#{module}/tasks")


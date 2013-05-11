fs = require('fs')

module.exports = (grunt) ->
  grunt.util._([
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
  ]).each (module) ->
    if fs.existsSync("node_modules/#{module}")
      grunt.loadNpmTasks(module)
    else
      grunt.loadTasks(__dirname+"/../node_modules/#{module}/tasks")


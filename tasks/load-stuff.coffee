fs = require('fs')

module.exports = (grunt) ->
  appNpmTasks = require(process.cwd() + "/config/application").appNpmTasks ? []
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

  grunt.util._
    .chain(linemanNpmTasks)
    .union(appNpmTasks)
    .each (module) ->
      if fs.existsSync("node_modules/#{module}")
        grunt.loadNpmTasks(module)
      else
        grunt.loadTasks(__dirname+"/../node_modules/#{module}/tasks")


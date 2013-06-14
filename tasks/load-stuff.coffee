fs = require('fs')

module.exports = (grunt) ->
  config = require("#{process.cwd()}/config/application")
  linemanNpmTasks = [
    "grunt-contrib-clean",
    "grunt-contrib-coffee",
    "grunt-contrib-concat",
    "grunt-contrib-handlebars",
    "grunt-contrib-jshint",
    "grunt-contrib-jst",
    "grunt-contrib-less",
    "grunt-contrib-cssmin",
    "grunt-contrib-uglify",
    "grunt-watch-nospawn"
  ]

  grunt.util._(linemanNpmTasks).
    chain().
    union(if config.enableSass then "grunt-contrib-sass" else []).
    union(config.loadNpmTasks || []).
    each (module) ->
      if fs.existsSync("#{process.cwd()}/node_modules/#{module}")
        grunt.loadNpmTasks(module)
      else
        grunt.loadTasks("#{__dirname}/../node_modules/#{module}/tasks")


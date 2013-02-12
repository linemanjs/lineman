module.exports = (grunt) ->

  grunt.util._([
    "grunt-contrib-clean",
    "grunt-contrib-coffee",
    "grunt-contrib-concat",
    "grunt-contrib-handlebars",
    "grunt-contrib-jshint",
    "grunt-contrib-jst",
    "grunt-contrib-less",
    "grunt-contrib-mincss",
    "grunt-contrib-uglify",
    "grunt-regarde"
  ]).each (module) ->
    grunt.loadNpmTasks "lineman/node_modules/#{module}"
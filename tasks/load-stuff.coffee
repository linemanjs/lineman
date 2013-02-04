module.exports = (grunt) ->
  grunt.util._([
    "grunt-contrib-jshint",
    "grunt-contrib-concat",
    "grunt-contrib-coffee",
    "grunt-contrib-less",
    "grunt-contrib-handlebars",
    "grunt-contrib-jst",
    "grunt-contrib-watch",
    "grunt-contrib-clean",
    "grunt-contrib-uglify"
  ]).each (module) ->
    grunt.loadNpmTasks "lineman/node_modules/#{module}"
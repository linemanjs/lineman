_ = require('grunt').util._

module.exports =
  run: (grunt) ->
    grunt.initConfig(userConfig())
    grunt.loadTasks("#{__dirname}/../tasks") #Lineman-defined tasks/
    grunt.loadTasks("tasks") #User-defined tasks/

userConfig = () ->
  _(require("#{process.cwd()}/config/application")).extend
    files: require("#{process.cwd()}/config/files")

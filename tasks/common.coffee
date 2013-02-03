###
Task: common
Description: runs linemans common lifecycle tasks
Dependencies: grunt
Contributor: @davemo
###
module.exports = (grunt) ->
  _ = grunt.util._
  grunt.registerTask "common", "runs linemans common lifecycle tasks", ->
    appTasks = require(process.cwd() + "/config/application").appTasks
    grunt.task.run appTasks.common


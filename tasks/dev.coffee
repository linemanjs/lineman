###
Task: dev
Description: runs linemans dev lifecycle tasks
Dependencies: grunt
Contributor: @davemo
###
module.exports = (grunt) ->
  _ = grunt.util._
  grunt.registerTask "dev", "runs linemans dev lifecycle tasks", ->
    appTasks = require(process.cwd() + "/config/application").appTasks
    grunt.task.run appTasks.dev


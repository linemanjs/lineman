###
Task: dist
Description: runs linemans dist lifecycle tasks
Dependencies: grunt
Contributor: @davemo
###
module.exports = (grunt) ->
  _ = grunt.util._
  grunt.registerTask "dist", "runs linemans dist lifecycle tasks", ->
    appTasks = require(process.cwd() + "/config/application").appTasks
    grunt.task.run appTasks.dist


###
Task: dist
Description: runs linemans dist lifecycle tasks
Dependencies: grunt
Contributor: @davemo
###

gatherTasks = require("./../lib/gather-tasks")

module.exports = (grunt) ->
  grunt.registerTask "dist", "runs linemans dist lifecycle tasks", ->
    grunt.task.run(gatherTasks("dist"))

###
Task: common
Description: runs linemans common lifecycle tasks
Dependencies: grunt
Contributor: @davemo
###

gatherTasks = require("./../lib/gather-tasks")

module.exports = (grunt) ->
  grunt.registerTask "common", "runs linemans common lifecycle tasks", ->
    grunt.task.run(gatherTasks("common"))


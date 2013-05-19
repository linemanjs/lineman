###
Task: dev
Description: runs linemans dev lifecycle tasks
Dependencies: grunt
Contributor: @davemo
###

gatherTasks = require("./../lib/gather-tasks")

module.exports = (grunt) ->
  grunt.registerTask "dev", "runs linemans dev lifecycle tasks", ->
    grunt.task.run(gatherTasks("dev"))



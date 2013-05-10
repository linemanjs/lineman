module.exports =
  run: (grunt) ->
    grunt.loadTasks(__dirname+"/../tasks") #Lineman-defined tasks/
    grunt.loadTasks("tasks") #User-defined tasks/
    grunt.task.run("configure")

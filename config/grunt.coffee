module.exports = run: (grunt) ->
  grunt.loadTasks "tasks"
  grunt.loadNpmTasks "lineman"
  grunt.task.run "configure"

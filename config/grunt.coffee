
buildsAppConfig = require('./../lib/builds-app-config')

module.exports =
  run: (grunt) ->
    grunt.registerTask('default', []);
    grunt.initConfig(buildsAppConfig.withUserOverrides())
    grunt.loadTasks("#{__dirname}/../tasks") #Lineman-defined tasks/
    grunt.loadTasks("tasks") #User-defined tasks/

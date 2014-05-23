findsPluginModules = require('./../lib/finds-plugin-modules')
buildsAppConfig = require('./../lib/builds-app-config')
fs = require('fs')

module.exports =
  run: (grunt) ->
    grunt.registerTask('default', [])
    grunt.initConfig(buildsAppConfig.forGrunt())
    loadLinemanTasks(grunt)
    loadPluginTasks(grunt)
    loadUserTasks(grunt)

loadLinemanTasks = (grunt) -> grunt.loadTasks("#{__dirname}/../tasks")

loadPluginTasks = (grunt) ->
  findsPluginModules.find().forEach (plugin) ->
    taskPath = "#{plugin.dir}/tasks"
    grunt.loadTasks(taskPath) if fs.existsSync(taskPath)

loadUserTasks = (grunt) ->
  grunt.loadTasks("tasks")



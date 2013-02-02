/**
 * Task: dev
 * Description: runs linemans dev lifecycle tasks
 * Dependencies: grunt
 * Contributor: @davemo
 */

module.exports = function(grunt) {
  var _ = grunt.util._;

  grunt.registerTask('dev', 'runs linemans dev lifecycle tasks', function(){
    var appTasks = require(process.cwd() + '/config/application.js').appTasks;
    grunt.task.run(appTasks.dev);
  });
};

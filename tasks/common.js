/**
 * Task: common
 * Description: runs linemans common lifecycle tasks
 * Dependencies: grunt
 * Contributor: @davemo
 */

module.exports = function(grunt) {
  var _ = grunt.util._;

  grunt.registerTask('common', 'runs linemans common lifecycle tasks', function(){
    var appTasks = require(process.cwd() + '/config/application').appTasks;
    grunt.task.run(appTasks.common);
  });
};

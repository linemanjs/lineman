/*global module:false*/
module.exports = function(grunt) {
  var _ = grunt.utils._,
      appTasks = require(process.cwd() + '/config/application.js').appTasks;

  grunt.loadTasks('tasks');
  grunt.loadNpmTasks('grunt-contrib');
  grunt.loadNpmTasks('lineman');

  grunt.registerTask('default', _.union(appTasks.common, appTasks.dist).join(' '));
  grunt.registerTask('run', _.union(appTasks.common, appTasks.watch).join(' '));

  grunt.task.run('configure');
};

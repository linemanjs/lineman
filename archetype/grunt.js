/*global module:false*/
module.exports = function(grunt) {
  var _ = grunt.utils._,
      appTasks = require(process.cwd() + '/config/application.js').appTasks,
      defaultAppTasks = _(appTasks).flatten();

  grunt.loadTasks('tasks');
  grunt.loadNpmTasks('grunt-contrib');
  grunt.loadNpmTasks('groan');

  grunt.registerTask('default', defaultAppTasks);
  grunt.registerTask('run', appTasks.common.join(' ')+' server watch');

  grunt.task.run('configure');
};

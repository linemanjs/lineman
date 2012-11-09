module.exports = {
  run: function(grunt) {
    grunt.loadTasks('tasks');
    grunt.loadNpmTasks('grunt-contrib');
    grunt.loadNpmTasks('lineman');
    grunt.task.run('configure');
  }
};


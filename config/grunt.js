module.exports = {
  run: function(grunt) {
    grunt.loadTasks('tasks');
    grunt.loadNpmTasks('lineman');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-handlebars');
    grunt.loadNpmTasks('grunt-contrib-jst');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.task.run('configure');
  }
};


/**
 * Task: images
 * Description: copy images to dist/img
 * Dependencies: grunt, underscore
 * Contributor: @searls
 */

module.exports = function(grunt) {
  var _ = grunt.utils._;

  grunt.registerTask('images', 'copy images to dist/img', function(target){
    target = target || "dist";

    this.requiresConfig("images.files");
    this.requiresConfig("images."+target);

    var targetConfig = grunt.config.get("images."+target);

    _(grunt.config.get("images.files")).each(function(files, basePath) {
      _(grunt.file.expand(files)).each(function(file) {
        grunt.file.copy(file, targetConfig.dest+'/'+file.replace(basePath,""));
      });
    });
  });
};
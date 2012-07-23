/**
 * Task: images
 * Description: copy images to dist/img
 * Dependencies: grunt
 * Contributor: @searls
 */

module.exports = function(grunt) {
  var _ = grunt.utils._,
      copy = require(__dirname+"/../lib/file-utils.js").copy;

  grunt.registerTask('images', 'copy images to dist/img', function(target){
    target = target || "dist";

    this.requiresConfig("images.files");
    this.requiresConfig("images."+target);

    var targetConfig = grunt.config.get("images."+target);

    _(grunt.config.get("images.files")).each(function(files, basePath) {
      _(grunt.file.expand(files)).each(function(src) {
        var dest = targetConfig.dest+'/'+src.replace(basePath,"");
        copy(src, dest);
      });
    });
  });
};
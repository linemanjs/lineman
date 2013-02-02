/**
 * Task: webfonts
 * Description: copy webfonts from 'vendor/webfonts' to 'generated' & 'dist'
 * Dependencies: grunt
 * Contributor: @davemo
 *
 * Configuration:
 *   "root" - the path to which webfonts will be copied under 'generated' and 'dist' (default: "webfonts")
 */

module.exports = function(grunt) {
  var _ = grunt.util._,
      copy = require(__dirname+"/../lib/file-utils.js").copy;

  grunt.registerTask('webfonts', 'copy webfonts to dist/webfonts', function(target){
    target = target || "dist";

    this.requiresConfig("webfonts.files");
    this.requiresConfig("webfonts."+target);

    var taskConfig = grunt.config.get("webfonts"),
        targetConfig = grunt.config.get("webfonts."+target),
        destinationPath = targetConfig.dest+'/'+taskConfig.root;

    grunt.log.writeln("Copying webfonts to '"+destinationPath+"'");

    _(taskConfig.files).each(function(files, basePath) {
      _(grunt.file.expand(files)).each(function(src) {
        var dest = destinationPath+'/'+src.replace(basePath,"");
        copy(src, dest);
      });
    });
  });
};

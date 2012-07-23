/* Synchronous file helpers */

var grunt = require("grunt");

module.exports = (function(_, fs, grunt) {
  return _({}).tap(function(exports) {
    exports.copy = function(src, dest) {
      var file = fs.lstatSync(src);

      if(file.isDirectory()) {
        exports.copyDir(src, dest);
      } else {
        grunt.file.copy(src, dest)
        grunt.log.writeln("Copied image '"+src+"' to '"+dest+"'")
      }
    };

    exports.copyDir = function(src, dest) {
      mkdirIfNecessary(src, dest);

      var paths = fs.readdirSync(src);
      _(paths).each(function(path) {
        exports.copy(src+"/"+path, dest+"/"+path);
      });
    };

    var mkdirIfNecessary = function(src, dest) {
      var checkDir = fs.statSync(src);
      try {
        fs.mkdirSync(dest, checkDir.mode);
      } catch (e) {
        if (e.code !== 'EEXIST') {
          throw e;
        }
      }
    };
  });
})(grunt.utils._, require("fs"), grunt);
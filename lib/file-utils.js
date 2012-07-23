/* Synchronous file helpers */

var grunt = require("grunt");

module.exports = (function(_, fs, log) {
  return _({}).tap(function(exports) {
    exports.copy = function(src, dest) {
      var file = fs.lstatSync(src);

      if(file.isDirectory()) {
        exports.copyDir(src, dest);
      } else if(file.isSymbolicLink()) {
        exports.copySymbolicLink(src, dest)
      } else {
        exports.copyFile(src, dest);
        log.writeln("Copied image '"+src+"' to '"+dest+"'")
      }
    };

    exports.copyFile = function(src, dest) {
      fs.writeFileSync(dest, fs.readFileSync(src));
    };

    exports.copySymbolicLink = function(src, dest) {
      fs.symlinkSync(fs.readlinkSync(src), dest);
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
})(grunt.utils._, require("fs"), grunt.log);
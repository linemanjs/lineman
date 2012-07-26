/* Synchronous file helpers */

var grunt = require("grunt"),
    fs = require("fs");

module.exports = (function(_, fs, grunt) {
  return _({}).tap(function(exports) {
    exports.copy = function(src, dest) {
      var file = fs.lstatSync(src);

      if(file.isDirectory()) {
        exports.copyDir(src, dest);
      } else {
        grunt.file.copy(src, dest);
        // grunt.log.writeln("Copied image '"+src+"' to '"+dest+"'");
      }
    };

    exports.copyDir = function(src, dest) {
      mkdirIfNecessary(src, dest);

      var paths = fs.readdirSync(src);
      _(paths).each(function(path) {
        exports.copy(src+"/"+path, dest+"/"+path);
      });
    };

    exports.overwritePackageJson = function(src, name) {
      var linemanPackageJson = grunt.file.readJSON(__dirname + "/../package.json"),
          newPackageJson = _(grunt.file.read(src)).template({
            name: _(name).dasherize(),
            versions: {
              lineman: "~"+linemanPackageJson["version"],
              grunt: linemanPackageJson["dependencies"]["grunt"],
              gruntContrib: linemanPackageJson["dependencies"]["grunt-contrib"],
              testacular: linemanPackageJson["dependencies"]["testacular"]
            }
          });
      grunt.file.write(src, newPackageJson);
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
})(grunt.utils._, fs, grunt);
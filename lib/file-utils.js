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

    exports.loadConfigurationFile = function(name) {
      //TODO: I don't like using try/catch for flow control but
      //  fs.existSync != require's ability to find modules, b/c require
      //  supports multiple extension lookup.
      try {
        return require(process.cwd() + '/config/' + name);
      } catch(e) {
        if(e.code === "MODULE_NOT_FOUND") {
          return {};
        } else {
          throw e;
        }
      }
    }

    exports.overwritePackageJson = function(src, name) {
      var linemanPackageJson = grunt.file.readJSON("./../package.json"),
          newPackageJson = _(grunt.file.read(src)).template({
            name: _(name).dasherize(),
            versions: {
              lineman                : "~"+linemanPackageJson["version"],
              grunt                  : linemanPackageJson["dependencies"]["grunt"],
              gruntContribJshint     : linemanPackageJson['dependencies']['grunt-contrib-jshint'],
              gruntContribConcat     : linemanPackageJson['dependencies']['grunt-contrib-concat'],
              gruntContribCoffee     : linemanPackageJson['dependencies']['grunt-contrib-coffee'],
              gruntContribLess       : linemanPackageJson['dependencies']['grunt-contrib-less'],
              gruntContribHandlebars : linemanPackageJson['dependencies']['grunt-contrib-handlebars'],
              gruntContribJst        : linemanPackageJson['dependencies']['grunt-contrib-jst'],
              gruntContribConnect    : linemanPackageJson['dependencies']['grunt-contrib-connect'],
              gruntContribWatch      : linemanPackageJson['dependencies']['grunt-contrib-watch'],
              gruntContribClean      : linemanPackageJson['dependencies']['grunt-contrib-clean'],
              gruntContribUglify     : linemanPackageJson['dependencies']['grunt-contrib-uglify'],
              testem                 : linemanPackageJson["dependencies"]["testem"]
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
})(grunt.util._, fs, grunt);

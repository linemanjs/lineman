var grunt = require("grunt"),
    exec = require('child_process').exec

module.exports = (function(_, exec) {
  return _({}).tap(function(exports) {
    exports.installFrom = function(path, callback) {
      process.chdir(path);
      console.info(" - Running `"+command+"` to install dependencies for your new project...");
      exec(command, function(error, stdout, stderr) {
        if(error) {
          console.error("Uh oh! An error occurred while running `"+command+"`. Error: \n\n"+error);
          console.error(stderr);
        }
        callback(error);
      });
    };

    var command = "npm install";

  });
})(grunt.utils._, exec);
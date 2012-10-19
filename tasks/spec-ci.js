/**
 * Task: spec-ci
 * Description: run specs in ci mode
 * Dependencies: grunt
 * Contributor: @dmosher
 */

module.exports = function(grunt) {
  var _ = grunt.utils._,
      path = require('path'),
      spawn = require('child_process').spawn;

  grunt.registerTask('spec-ci', 'run specs in ci mode', function(target){
    var done = this.async();
        args = ["ci", "-f", path.resolve(process.cwd()+"/config/spec.json")],
        child = spawn(process.cwd()+"/node_modules/testem/testem.js", args),
        output = "";

    child.stdout.on('data', function(chunk){
      process.stdout.write(chunk);
      output += chunk;
    });
    child.on('exit', function(code, signal){
      if(code !== 0 || testsFailed(output)) {
        grunt.warn("Spec execution appears to have failed.");
        done(false);
      } else {
        done();
      }
    });
  });
};

var testsFailed = function(output) {
  var lines = output.split("\n"),
      summaryLine = lines[lines.length - 2];
  return summaryLine !== "# ok";
};

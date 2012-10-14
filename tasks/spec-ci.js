/**
 * Task: spec-ci
 * Description: run specs in ci mode
 * Dependencies: grunt
 * Contributor: @dmosher
 */

module.exports = function(grunt) {
  var _ = grunt.utils._,
      path = require('path'),
      fork = require('child_process').fork;

  grunt.registerTask('spec-ci', 'run specs in ci mode', function(target){
    var done = this.async();
    var args = ["ci", "-f", path.resolve(process.cwd()+"/config/spec.json")];
    child = fork(process.cwd()+"/node_modules/testem/testem.js", args)
    child.on('exit', function(code, signal){
      if(code !== 0) {
        grunt.warn("Spec execution failed with exit code "+code);
      }
      done();
    });
  });

};
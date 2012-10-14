/**
 * Task: spec
 * Description: run specs
 * Dependencies: grunt
 * Contributor: @searls
 */

module.exports = function(grunt) {
  var _ = grunt.utils._,
      path = require('path'),
      fork = require('child_process').fork;

  grunt.registerTask('spec', 'run specs', function(target){
    var done = this.async();
    var args = ["-f", path.resolve(process.cwd()+"/config/spec.json")];
    child = fork(process.cwd()+"/node_modules/testem/testem.js", args)
    child.on('exit', function(code, signal){
      if(code !== 0) {
        grunt.warn("Spec execution failed with exit code "+code);
      }
      done();
    });
  });

};
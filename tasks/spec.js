/**
 * Task: spec
 * Description: run specs
 * Dependencies: grunt
 * Contributor: @searls
 */

module.exports = function(grunt) {
  var _ = grunt.utils._,
      path = require('path'),
      fork = require('child_process').fork,
      adapters = {
        jasmine: [
          //FIXME there has to be a better way to ask for a module's directory, no?
          process.cwd() + "/node_modules/testacular/adapter/lib/jasmine.js",
          process.cwd() + "/node_modules/testacular/adapter/jasmine.js"
        ]
      };



  grunt.registerTask('spec', 'run specs', function(target){
    var once = (target || "once") === "once",
        files = grunt.file.expand(grunt.config.get("spec.files")),
        options = _({
                  basePath: process.cwd(), //'../..' ??
                  files: _.union(adapters.jasmine, files),
                  reporter: 'dots', // possible values: 'dots' || 'progress'
                  port: 9101,
                  runnerPort: 9100,
                  colors: true,
                  logLevel: 3, //translates to LOG_INFO in testacular/lib/constants.js
                  browsers: ["PhantomJS"],
                  autoWatch: !once,
                  singleRun: once
                }).extend(grunt.config.get("spec.config"));

    var done = this.async();
    child = fork(__dirname+"/spec/server.js", [path.resolve(__dirname+"/../config/spec.js"), JSON.stringify(options)])
    child.on('exit', function(code, signal){
      if(code !== 0) {
        grunt.warn("Spec execution failed with exit code "+code);
      }
      done();
    });
  });

};
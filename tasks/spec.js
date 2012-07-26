/**
 * Task: spec
 * Description: run specs
 * Dependencies: grunt
 * Contributor: @searls
 */

module.exports = function(grunt) {
  var _ = grunt.utils._,
  	  path = require('path'),
  	  server = require('testacular').server;

  grunt.registerTask('spec', 'run specs', function(target){
    //FIXME there has to be a better way to ask for a module's directory, no?

  	var jasmine = process.cwd() + "/node_modules/testacular/adapter/lib/jasmine.js",
        jasmineAdapter = process.cwd() + "/node_modules/testacular/adapter/jasmine.js", 
        once = (target || "once") === "once",
        files = grunt.config.get().files.glob,    
        patterns = _(files.js.app).chain().union(files.js.spec).flatten().value(),
        options = {
          basePath: process.cwd(), //'../..' ??
          files: [jasmine, jasmineAdapter].concat(patterns),
          reporter: 'dots', // possible values: 'dots' || 'progress'
          port: 9101,
          runnerPort: 9100,
          colors: true,
          logLevel: 3, //translates to LOG_INFO in testacular/lib/constants.js
          browsers: ["PhantomJS"],
          autoWatch: !once,
          singleRun: once
      	};
    
//FIXME: testacular has no callback, so we can't call done()... however, singleRun will kill the process... not exactly a solution
var done = this.async();

    server.start(path.resolve(__dirname+"/../config/spec.js"), options);
  });
};
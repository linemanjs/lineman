/**
 * Task: configure
 * Description: (Re-)initializes the grunt config by combining the exported config in
 *                /config/application.js & a (re-)expansion of all the filepaths in
 *                /config/files.js
 * Dependencies: grunt, underscore
 * Contributor: @searls
 */

module.exports = function(grunt) {
  var _ = grunt.utils._;


  var expandFiles = function(files, parent) {
    return _(parent || {}).tap(function(parent) {
      _(files).each(function(file, name) {
        if (_(file).isString() || _(file).isArray()) {
          parent[name] = grunt.file.expand(file);
        } else if (_(file).isObject()) {
          parent[name] = {};
          expandFiles(file, parent[name]);
        }
      });
    });
  };

  grunt.registerTask('configure', '(Re-)expands all file paths and (re-)initializes the grunt config', function(){
    var application = require(process.cwd() + '/config/application.js'),
        files = require(process.cwd() + '/config/files.js');
        expandedFiles = _(expandFiles(files)).extend({glob: files})
    grunt.initConfig(_(application).extend({files: expandedFiles}));
  });
};
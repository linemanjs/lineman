require('coffee-script');
defaults = require('./lib/builds-app-config').default();

module.exports = {
  config: {
    application: defaults.application,
    files: defaults.files,
    grunt: require(__dirname+"/config/grunt"),
    extend: require(__dirname+"/lib/extend")
  },
  lib: {
    fileUtils: require(__dirname+"/lib/file-utils")
  },
  grunt: require('grunt'),
  version: require(__dirname+"/package").version
};

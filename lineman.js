require('coffee-script');
var path = require('path'),
    linemanDir = require('./finds-lineman-dir').find(),
    requiresGrunt = require(path.join(linemanDir, "lib", "requires-grunt")),
    defaults = require(path.join(linemanDir, "lib", "builds-app-config")).default();

module.exports = {
  config: {
    application: defaults.application,
    files: defaults.files,
    grunt: require(path.join(linemanDir, "config", "grunt")),
    extend: require(path.join(linemanDir, "lib", "extend"))
  },
  lib: {
    fileUtils: require(path.join(linemanDir, "lib", "file-utils"))
  },
  grunt: requiresGrunt.require(),
  version: require(path.join(linemanDir, "package")).version
};

# Exports an object that defines
# *  all of the configuration needed by the projects'
# *  depended-on grunt tasks.
#
grunt = require("./../lib/requires-grunt").require()
module.exports =
  pkg: grunt.file.readJSON("package.json")
  meta:
    banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"

  appTasks:
    common: ["coffee", "less", "jshint", "handlebars", "jst", "concat_sourcemap", "copy:dev", "images:dev", "webfonts:dev", "pages:dev"]
    dev: ["server", "watch"]
    dist: ["uglify", "cssmin", "copy:dist", "images:dist", "webfonts:dist", "pages:dist"]

  removeTasks:
    common: []
    dev: []
    dist: []

  prependTasks:
    common: []
    dev: []
    dist: []

  appendTasks:
    common: []
    dev: []
    dist: []

  loadNpmTasks: []

  enableSass: false
  enableAssetFingerprint: false

# Exports an object that defines
# *  all of the configuration needed by the projects'
# *  depended-on grunt tasks.
#
grunt = require("./../lib/requires-grunt").require()
normalizePackage = require("normalize-package-data")

normalizedPackageJson = (packageFile = "package.json") ->
  pkg = grunt.file.readJSON(packageFile)
  normalizePackage pkg
  pkg

module.exports =
  pkg: normalizedPackageJson()
  meta:
    banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"

  appTasks:
    common: ["coffee", "jshint", "handlebars", "jst", "concat_sourcemap", "copy:dev", "images:dev", "webfonts:dev", "pages:dev"]
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

###
Task: configure
Description: "Extends Lineman's config with the user-defined configuration & file globs"
Dependencies: grunt
Contributor: @searls
###
module.exports = (grunt) ->
  _ = grunt.util._

  grunt.registerTask "configure", "Extends Lineman's config with the user-defined configuration & file globs", ->
    grunt.initConfig _(require(process.cwd() + "/config/application")).extend
      files: require(process.cwd() + "/config/files")


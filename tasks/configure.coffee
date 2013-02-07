###
Task: configure
Description: (Re-)initializes the grunt config by combining the exported config in
/config/application.js & a (re-)expansion of all the filepaths in
/config/files.js
Dependencies: grunt, underscore
Contributor: @searls
###
module.exports = (grunt) ->
  _ = grunt.util._
  expandFiles = (files, parent) ->
    _(parent or {}).tap (parent) ->
      _(files).each (file, name) ->
        if _(file).isString() or _(file).isArray()
          parent[name] = grunt.file.expand(file)
        else if _(file).isObject()
          parent[name] = {}
          expandFiles(file, parent[name])

  grunt.registerTask "configure", "(Re-)expands all file paths and (re-)initializes the grunt config", ->
    application = require(process.cwd() + "/config/application")
    files = require(process.cwd() + "/config/files")
    expandedFiles = _(expandFiles(files)).extend(glob: files)
    grunt.initConfig _(application).extend(files: expandedFiles)


###
Task: webfonts
Description: copy webfonts from 'vendor/webfonts' to 'generated' & 'dist'
Dependencies: grunt
Contributor: @davemo

Configuration:
"root" - the path to which webfonts will be copied under 'generated' and 'dist' (default: "webfonts")
###
module.exports = (grunt) ->
  _ = require("lodash")
  copy = require(__dirname + "/../lib/file-utils").copy

  grunt.registerTask "webfonts", "copy webfonts to dist/webfonts", (target) ->
    target = target or "dist"
    @requiresConfig "webfonts.files"
    @requiresConfig "webfonts.#{target}"
    taskConfig = grunt.config.get("webfonts")
    targetConfig = grunt.config.get("webfonts.#{target}")
    destinationPath = "#{targetConfig.dest}/#{taskConfig.root}"

    if grunt.config("webfonts.#{target}.files")? or grunt.config("webfonts.#{target}.src")?
      grunt.warn """
                 The 'webfonts' task implementation has been reverted. It currently does not
                 support the grunt-contrib-copy style configuration, which has been detected in
                 your setup. You will likely need to configure 'webfonts.vendor' and/or
                 'webfonts.root' in 'config/files.js'.
                 """

    grunt.log.writeln "Copying webfonts to '#{destinationPath}'"
    _(taskConfig.files).each (files, basePath) ->
      _(grunt.file.expand(files)).each (src) ->
        dest = "#{destinationPath}/#{src.replace(basePath, "")}"
        copy(src, dest)




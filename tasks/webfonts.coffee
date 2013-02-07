###
Task: webfonts
Description: copy webfonts from 'vendor/webfonts' to 'generated' & 'dist'
Dependencies: grunt
Contributor: @davemo

Configuration:
"root" - the path to which webfonts will be copied under 'generated' and 'dist' (default: "webfonts")
###
module.exports = (grunt) ->
  _ = grunt.util._
  copy = require(__dirname + "/../lib/file-utils").copy

  grunt.registerTask "webfonts", "copy webfonts to dist/webfonts", (target) ->
    target = target or "dist"
    @requiresConfig "webfonts.files"
    @requiresConfig "webfonts.#{target}"
    taskConfig = grunt.config.get("webfonts")
    targetConfig = grunt.config.get("webfonts.#{target}")
    destinationPath = "#{targetConfig.dest}/#{taskConfig.root}"

    grunt.log.writeln "Copying webfonts to '#{destinationPath}'"
    _(taskConfig.files).each (files, basePath) ->
      _(grunt.file.expand(files)).each (src) ->
        dest = "#{destinationPath}/#{src.replace(basePath, "")}"
        copy(src, dest)




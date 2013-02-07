###
Task: images
Description: copy images from 'app/img' & 'vendor/img' to 'generated' & 'dist'
Dependencies: grunt
Contributor: @searls

Configuration:
"root" - the path to which images will be copied under 'generated' and 'dist' (default: "img")
###
module.exports = (grunt) ->
  _ = grunt.util._
  copy = require("./../lib/file-utils").copy

  grunt.registerTask "images", "copy images to dist/img", (target) ->
    target = target || "dist"
    @requiresConfig("images.files")
    @requiresConfig("images.#{target}")
    taskConfig = grunt.config.get("images")
    targetConfig = grunt.config.get("images.#{target}")
    destinationPath = "#{targetConfig.dest}/#{taskConfig.root}"

    grunt.log.writeln("Copying images to '#{destinationPath}'")
    _(taskConfig.files).each (files, basePath) ->
      _(grunt.file.expand(files)).each (src) ->
        dest = "#{destinationPath}/#{src.replace(basePath, "")}"
        copy(src, dest)




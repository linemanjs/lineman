###
Task: images
Description: copy images from 'app/img' & 'vendor/img' to 'generated' & 'dist'
Dependencies: grunt
Contributor: @searls

Configuration:
"root" - the path to which images will be copied under 'generated' and 'dist' (default: "img")
###
_ = require("lodash")

module.exports = (grunt) ->
  copy = require("./../lib/file-utils").copy

  grunt.registerTask "images", "copy images to dist/img", (target) ->
    target = target || "dist"
    @requiresConfig("images.files")
    @requiresConfig("images.#{target}")
    taskConfig = grunt.config.get("images")
    targetConfig = grunt.config.get("images.#{target}")
    destinationPath = "#{targetConfig.dest}/#{taskConfig.root}"

    if grunt.config("images.#{target}.files")? or grunt.config("images.#{target}.src")?
      grunt.warn """
                 The 'images' task implementation has been reverted. It currently does not
                 support the grunt-contrib-copy style configuration, which has been detected in
                 your setup. You will likely need to configure 'img.app', 'img.vendor' and/or
                 'img.root' in 'config/files.js'.
                 """

    grunt.log.writeln("Copying images to '#{destinationPath}'")
    _(taskConfig.files).each (files, basePath) ->
      _(grunt.file.expand(files)).each (src) ->
        dest = "#{destinationPath}/#{src.replace(basePath, "")}"
        copy(src, dest)




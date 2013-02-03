###
Task: homepage
Description: copies a home page html file for the project dist directory
Dependencies: grunt, fs
Contributor: @searls

options:
template - [required] path to the homepage template file
format - [optional] type of the template (if not provided, the file extension will be used)

Supported formats:
html - template will merely be copied
underscore (aliases: "us", "jst") - underscore templating
handlebar (aliases: "hb", "handlebars") - handlebars templating

When the template is processed, it will be passed the grunt configuration object,
which contains lots of useful goodies.
###
module.exports = (grunt) ->
  fs = require("fs")
  _ = grunt.util._
  extensionOf = (fileName) ->
    _(fileName.match(/[^.]*$/)).last()

  grunt.registerTask "homepage", "generates a home page html file for the project dist directory", (target) ->
    target = target or "dist"
    @requiresConfig "homepage.template"
    @requiresConfig "homepage." + target
    template = grunt.config.get("homepage.template")
    targetConfig = grunt.config.get("homepage." + target)
    format = (grunt.config.get("homepage.format") or extensionOf(template) or "html").toLowerCase()
    if format is "html"
      grunt.file.copy template, targetConfig.dest
    else
      source = grunt.file.read(template)
      context = _(grunt.config.get()).extend(targetConfig.context)
      html = undefined
      if _(["underscore", "us", "jst"]).include(format)
        html = _(source).template()(context)
      else html = require("handlebars").compile(source)(context)  if _(["handlebar", "hb", "handlebars"]).include(format)
      grunt.file.write targetConfig.dest, html
    grunt.log.writeln "Homepage HTML written to '" + targetConfig.dest + "'"


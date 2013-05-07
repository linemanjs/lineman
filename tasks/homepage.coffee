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

  grunt.registerTask "homepage", "generates a home page html file for the project dist directory", (target) ->
    target = target || "dist"
    @requiresConfig("homepage.template")
    @requiresConfig("homepage.#{target}")
    template = grunt.config.get("homepage.template")
    targetConfig = grunt.config.get("homepage.#{target}")
    format = (grunt.config.get("homepage.format") || extensionOf(template) || "html").toLowerCase()
    if format == "html"
      grunt.file.copy(template, targetConfig.dest)
    else
      source = grunt.file.read(template)
      context = _(grunt.config.get()).extend(targetConfig.context)
      grunt.file.write(targetConfig.dest, htmlFor(format, source, context))

    grunt.log.writeln("Homepage HTML written to '#{targetConfig.dest}'")

  extensionOf = (fileName) ->
    _(fileName.match(/[^.]*$/)).last()

  htmlFor = (format, source, context) ->
    if _(["underscore", "us", "jst"]).include(format)
      _(source).template()(context)
    else if _(["handlebar", "hb", "handlebars"]).include(format)
      locateHandlebars().compile(source)(context)
    else
      ""

  locateHandlebars = ->
    handlebarsPath = process.cwd()+'/node_modules/handlebars'
    if fs.existsSync(handlebarsPath)
      require(handlebarsPath)
    else
      grunt.log.writeln('NOTE: please add the `handlebars` module to your package.json, as Lineman doesn\'t include it directly. Attempting to Handlebars load naively (this may blow up).').
      require("handlebars")

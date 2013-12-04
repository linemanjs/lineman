###
Task: pages
Description: generates static HTML files
Dependencies: grunt, fs
Contributor: @searls, @adamlogic

Supported formats:
html - template will merely be copied
underscore (aliases: "us", "jst") - underscore templating
handlebar (aliases: "hb", "handlebars") - handlebars templating

When the templates are processed, they will be passed the grunt configuration object,
which contains lots of useful goodies.
###
fs = require("fs")
_  = require("underscore")

module.exports = (grunt) ->

  grunt.registerMultiTask "pages", "generates static HTML files", ->
    for filePair in @files
      for src in filePair.src
        format = (extensionOf(src) || "html").toLowerCase()
        dest = if filePair.dest.match(/\.html$/)
          filePair.dest
        else
          [ filePair.dest.replace(/\/$/,''),
            src.replace(/.*\//, '').replace(/\..+$/, '.html') ].join '/'

        if format == "html"
          grunt.file.copy(src, dest)
        else
          source = grunt.file.read(src)
          context = buildTemplateContext(this)
          grunt.file.write(dest, htmlFor(format, source, context))

        grunt.log.writeln("#{dest} generated from #{src}")

  extensionOf = (fileName) ->
    _(fileName.match(/[^.]*$/)).last()

  htmlFor = (format, source, context) ->
    if format in ["underscore", "us", "jst"]
      _(source).template()(context)
    else if format in ["handlebar", "hb", "handlebars"]
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

  buildTemplateContext = (task) ->
    _(grunt.config.get()).
      chain().
      extend(task.data.context).
      tap( (context) ->
        overrideTemplateContextWithFingerprints(context, task)
      ).value()

  overrideTemplateContextWithFingerprints = (context, task) ->
    return unless context.enableAssetFingerprint
    if task.target == "dist"
      manifest = JSON.parse(grunt.file.read(context.files.assetFingerprint.manifest))
      context.assets = _({}).extend(context.assets, manifest)
      context.js = context.assets[context.js] if context.js?
      context.css = context.assets[context.css] if context.css?
    else
      context.assets ||= {}

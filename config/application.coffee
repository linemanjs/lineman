# Exports an object that defines
# *  all of the configuration needed by the projects'
# *  depended-on grunt tasks.
#
grunt = require("grunt")
module.exports =
  pkg: grunt.file.readJSON("package.json")
  meta:
    banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"

  appTasks:
    common: ["coffee", "less", "jshint", "handlebars", "jst", "concat", "images:dev", "webfonts:dev", "pages:dev"]
    dev: ["server", "watch"]
    dist: ["uglify", "cssmin", "images:dist", "webfonts:dist", "pages:dist"]
  loadNpmTasks: []

  #code
  coffee:
    compile:
      files: [
        { src: "<%= files.coffee.app %>", dest: "<%= files.coffee.generated %>" }
        { src: "<%= files.coffee.spec %>", dest: "<%= files.coffee.generatedSpec %>" }
        { src: "<%= files.coffee.specHelpers %>", dest: "<%= files.coffee.generatedSpecHelpers %>" }
      ]

  #style
  less:
    options:
      paths: ["<%= files.dirs.app %>/<%= files.dirs.style %>", "<%= files.dirs.vendor %>/<%= files.dirs.style %>"]
    compile:
      files: [
        { src: "<%= files.less.app %>", dest: "<%= files.less.generatedApp %>" }
        { src: "<%= files.less.vendor %>", dest: "<%= files.less.generatedVendor %>" }
      ]

  enableSass: false
  sass:
    compile:
      options:
        loadPath: ["<%= files.dirs.app %>/<%= files.dirs.style %>", "<%= files.dirs.vendor %>/<%= files.dirs.style %>"]
      files: [
        { src: "<%= files.sass.main %>", dest: "<%= files.sass.generatedApp %>" }
      ]

  #templates
  handlebars:
    options:
      namespace: "JST"
      wrapped: true
    compile:
      files: [
        { src: "<%= files.template.handlebars %>", dest: "<%= files.template.generatedHandlebars %>" }
      ]

  jst:
    options:
      namespace: "JST"
    compile:
      files: [
        { src: "<%= files.template.underscore %>", dest: "<%= files.template.generatedUnderscore %>" }
      ]

  #quality
  spec:
    files: ["<%= files.js.concatenated %>", "<%= files.js.concatenatedSpec %>"]
    options:
      growl: false

  jshint:
    files: ["<%= files.js.app %>"]
    options:
      force: process.env['LINEMAN_RUN'] || false
      curly: true
      eqeqeq: true
      latedef: true
      newcap: true
      noarg: true
      sub: true
      undef: false
      boss: true
      eqnull: true
      browser: true

  #distribution
  concat:
    js:
      src: ["<banner:meta.banner>", "<%= files.js.vendor %>", "<%= files.template.generated %>", "<%= files.coffee.generated %>", "<%= files.js.app %>"]
      dest: "<%= files.js.concatenated %>"

    spec:
      src: ["<%= files.js.specHelpers %>", "<%= files.coffee.generatedSpecHelpers %>", "<%= files.js.spec %>", "<%= files.coffee.generatedSpec %>"]
      dest: "<%= files.js.concatenatedSpec %>"

    css:
      src: [
        "<%= files.less.generatedVendor %>",
        "<%= files.sass.generatedVendor %>",
        "<%= files.css.vendor %>",
        "<%= files.less.generatedApp %>",
        "<%= files.sass.generatedApp %>",
        "<%= files.css.app %>"
      ]
      dest: "<%= files.css.concatenated %>"

  # notes: due to ../../ paths for images in many css libs we dump images out to the root of dist and generated
  #        if your lib requires a different structure to counter this, you'll need to nest your img files in vendor/img accordingly, ie: vendor/img/img
  images:
    files: [
      { src: "<%= files.img.app %>", dest: "<%= files.dirs.app %>/<%= files.dirs.images %>/" }
      { src: "<%= files.img.vendor %>", dest: "<%= files.dirs.vendor %>/<%= files.dirs.images %>/" }
    ]

    root: "<%= files.img.root %>"
    dev:
      dest: "<%= files.dirs.gen %>"

    dist:
      dest: "<%= files.dirs.dist %>"

  webfonts:
    files: [
      { src: "<%= files.webfonts.vendor %>", dest: "<%= files.dirs.vendor %>/<%= files.dirs.fonts %>/" }
    ]

    root: "<%= files.webfonts.root %>"
    dev:
      dest: "<%= files.dirs.gen %>"

    dist:
      dest: "<%= files.dirs.dist %>"

  pages:
    dev:
      files: [
        { src: "<%= files.pages.source %>", dest: "<%= files.dirs.gen %>" }
        { src: "<%= files.dirs.app %>/<%= files.dirs.markup %>/homepage.*", dest: "<%= files.dirs.gen %>/index.html" } # backward compatibility
      ]
      context: {}
    dist:
      files: [
        { src: "<%= files.pages.source %>", dest: "<%= files.dirs.dist %>" }
        { src: "<%= files.dirs.app %>/<%= files.dirs.markup %>/homepage.*", dest: "<%= files.dirs.dist %>/index.html" } # backward compatibility
      ]
      context: {}

  #optimizing
  uglify:
    options:
      banner: "<%= meta.banner %>"
    js:
      files: [
        { src: "<%= files.js.concatenated %>", dest: "<%= files.js.minified %>" }
      ]

  cssmin:
    compress:
      files: [
        { src: "<%= files.css.concatenated %>", dest: "<%= files.css.minified %>" }
      ]

  #cleaning
  clean:
    js:
      src: "<%= files.js.concatenated %>"

    css:
      src: "<%= files.css.concatenated %>"

    dist:
      src: ["<%= files.dirs.dist %>", "<%= files.dirs.gen %>"]

  #productivity
  server:
    base: "<%= files.dirs.gen %>"
    web:
      port: 8000

    apiProxy:
      enabled: false
      host: "localhost"
      port: 3000

  watch:
    js:
      files: ["<%= files.js.vendor %>", "<%= files.js.app %>"]
      tasks: ["concat:js"]

    coffee:
      files: "<%= files.coffee.app %>"
      tasks: ["coffee", "concat:js"]

    jsSpecs:
      files: ["<%= files.js.specHelpers %>", "<%= files.js.spec %>"]
      tasks: ["concat:spec"]

    coffeeSpecs:
      files: ["<%= files.coffee.specHelpers %>", "<%= files.coffee.spec %>"]
      tasks: ["coffee", "concat:spec"]

    css:
      files: ["<%= files.css.vendor %>", "<%= files.css.app %>"]
      tasks: ["concat:css"]

    less:
      files: ["<%= files.less.vendor %>", "<%= files.less.app %>"]
      tasks: ["less", "concat:css"]

    sass:
      files: ["<%= files.sass.vendor %>", "<%= files.sass.app %>"]
      tasks: ["sass", "concat:css"]

    pages:
      files: ["<%= files.pages.source %>", "app/templates/homepage.us"]
      tasks: ["pages:dev"]

    handlebars:
      files: "<%= files.template.handlebars %>"
      tasks: ["handlebars", "concat:js"]

    underscore:
      files: "<%= files.template.underscore %>"
      tasks: ["jst", "concat:js"]

    images:
      files: ["<%= files.img.app %>", "<%= files.img.vendor %>"]
      tasks: ["images:dev"]

    lint:
      files: "<%= files.js.app %>"
      tasks: ["jshint"]

    webfonts:
      files: "<%= files.webfonts.vendor %>"
      tasks: ["webfonts:dev"]

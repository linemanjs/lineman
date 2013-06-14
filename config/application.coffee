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
    common: ["coffee", "less", "jshint", "handlebars", "jst", "concat", "images:dev", "webfonts:dev", "homepage:dev"]
    dev: ["server", "watch"]
    dist: ["uglify", "cssmin", "images:dist", "webfonts:dist", "homepage:dist"]
  loadNpmTasks: []

  #code
  coffee:
    compile:
      files:
        "generated/js/app.coffee.js": "<%= files.coffee.app %>"
        "generated/js/spec.coffee.js": "<%= files.coffee.spec %>"
        "generated/js/spec-helpers.coffee.js": "<%= files.coffee.specHelpers %>"

  #style
  less:
    options:
      paths: ["app/css", "vendor/css"]
    compile:
      files:
        "generated/css/vendor.less.css": "<%= files.less.vendor %>"
        "generated/css/app.less.css": "<%= files.less.app %>"

  enableSass: false
  sass:
    compile:
      options:
        loadPath: ["app/css", "vendor/css"]

      files:
        "generated/css/app.sass.css": "<%= files.sass.main %>"

  #templates
  handlebars:
    options:
      namespace: "JST"
      wrapped: true
    compile:
      files:
        "generated/template/handlebars.js": "<%= files.template.handlebars %>"

  jst:
    options:
      namespace: "JST"
    compile:
      files:
        "generated/template/underscore.js": "<%= files.template.underscore %>"

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
    files:
      "app/img/": "<%= files.img.app %>"
      "vendor/img/": "<%= files.img.vendor %>"

    root: "<%= files.img.root %>"
    dev:
      dest: "generated"

    dist:
      dest: "dist"

  webfonts:
    files:
      "vendor/webfonts/": "<%= files.webfonts.vendor %>"

    root: "<%= files.webfonts.root %>"
    dev:
      dest: "generated"

    dist:
      dest: "dist"

  homepage:
    template: "<%= files.template.homepage %>"
    dev:
      dest: "generated/index.html"
      context:
        js: "js/app.js"
        css: "css/app.css"

    dist:
      dest: "dist/index.html"
      context:
        js: "js/app.min.js"
        css: "css/app.min.css"

  #optimizing
  uglify:
    options:
      banner: "<%= meta.banner %>"
    js:
      files:
        "dist/js/app.min.js": "<%= files.js.concatenated %>"

  cssmin:
    compress:
      files:
        "dist/css/app.min.css": "<%= files.css.concatenated %>"

  #cleaning
  clean:
    js:
      src: "<%= files.js.concatenated %>"

    css:
      src: "<%= files.css.concatenated %>"

    dist:
      src: ["dist", "generated"]

  #productivity
  server:
    base: "generated"
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

    handlebars:
      files: "<%= files.template.handlebars %>"
      tasks: ["handlebars", "concat:js"]

    underscore:
      files: "<%= files.template.underscore %>"
      tasks: ["jst", "concat:js"]

    images:
      files: ["<%= files.img.app %>", "<%= files.img.vendor %>"]
      tasks: ["images:dev"]

    homepage:
      files: "<%= files.template.homepage %>"
      tasks: ["homepage:dev"]

    lint:
      files: "<%= files.js.app %>"
      tasks: ["jshint"]

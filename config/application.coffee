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
      files:
        "<%= files.coffee.generated %>": "<%= files.coffee.app %>"
        "<%= files.coffee.generatedSpec %>": "<%= files.coffee.spec %>"
        "<%= files.coffee.generatedSpecHelpers %>": "<%= files.coffee.specHelpers %>"

  #style
  less:
    options:
      paths: ["app/css", "vendor/css"]
    compile:
      files:
        "<%= files.less.generatedVendor %>": "<%= files.less.vendor %>"
        "<%= files.less.generatedApp %>": "<%= files.less.app %>"

  enableSass: false
  sass:
    compile:
      options:
        loadPath: ["app/css", "vendor/css"]
      files:
        "<%= files.sass.generatedApp %>": "<%= files.sass.main %>"

  #templates
  handlebars:
    options:
      namespace: "JST"
      wrapped: true
    compile:
      files:
        "<%= files.template.generatedHandlebars %>": "<%= files.template.handlebars %>"

  jst:
    options:
      namespace: "JST"
    compile:
      files:
        "<%= files.template.generatedUnderscore %>": "<%= files.template.underscore %>"

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
      src: ["<%= files.js.vendor %>", "<%= files.template.generated %>", "<%= files.coffee.generated %>", "<%= files.js.app %>"]
      dest: "<%= files.js.concatenated %>"
      options:
        banner: "<%= meta.banner %>"

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

  pages:
    dev:
      files:
        "generated": "<%= files.pages.source %>",
        "generated/index.html": "app/templates/homepage.*" # backward compatibility
      context:
        js: "js/app.js"
        css: "css/app.css"
    dist:
      files:
        "dist": "<%= files.pages.source %>",
        "dist/index.html": "app/templates/homepage.*" # backward compatibility
      context:
        js: "js/app.js"
        css: "css/app.css"

  #optimizing
  uglify:
    options:
      banner: "<%= meta.banner %>"
    js:
      files:
        "<%= files.js.minified %>": "<%= files.js.concatenated %>"

  cssmin:
    compress:
      files:
        "<%= files.css.minified %>": "<%= files.css.concatenated %>"

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
    options:
      spawn: false

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

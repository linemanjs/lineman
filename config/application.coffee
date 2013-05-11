# Exports an object that defines
# *  all of the configuration needed by the projects'
# *  depended-on grunt tasks.
#
grunt = require("grunt")
module.exports =
  pkg: grunt.file.readJSON("package.json")
  meta:
    banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - " + "<%= grunt.template.today(\"yyyy-mm-dd\") %>\\n" + "<%= pkg.homepage ? \"* \" + pkg.homepage + \"\\n\" : \"\" %>" + "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author.company %>;" + " Licensed <%= _.pluck(pkg.licenses, \"type\").join(\", \") %> */"

  appTasks:
    common: ["configure", "coffee", "less", "sass", "jshint", "handlebars", "jst", "concat:js", "concat:spec", "concat:css", "images:dev", "webfonts:dev", "homepage:dev"]
    dev: ["server", "watch"]
    dist: ["uglify:js", "cssmin", "images:dist", "webfonts:dist", "homepage:dist"]


  #code
  coffee:
    compile:
      files:
        "generated/js/app.coffee.js": "<%= files.glob.coffee.app %>"
        "generated/js/spec.coffee.js": "<%= files.glob.coffee.spec %>"
        "generated/js/spec-helpers.coffee.js": "<%= files.glob.coffee.specHelpers %>"


  #style
  less:
    compile:
      options:
        paths: ["app/css", "vendor/css"]

      files:
        "generated/css/vendor.less.css": "<%= files.glob.less.vendor %>"
        "generated/css/app.less.css": "<%= files.glob.less.app %>"

  sass:
    compile:
      options:
        includePaths: ["app/css", "vendor/css"]

      files:
        "generated/css/vendor.sass.css": "<%= files.glob.sass.vendor %>"
        "generated/css/app.sass.css": "<%= files.glob.sass.app %>"



  #templates
  handlebars:
    compile:
      options:
        namespace: "JST"
        wrapped: true

      files:
        "generated/template/handlebars.js": "<%= files.glob.template.handlebars %>"

  jst:
    compile:
      options:
        namespace: "JST"

      files:
        "generated/template/underscore.js": "<%= files.glob.template.underscore %>"


  #quality
  spec:
    files: ["<%= files.glob.js.concatenated %>", "<%= files.glob.js.concatenatedSpec %>"]

  jshint:
    files: ["<%= files.glob.js.app %>"]
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
      src: ["<banner:meta.banner>", "<%= files.glob.js.vendor %>", "<%= files.template.generated %>", "<%= files.coffee.generated %>", "<%= files.glob.js.app %>"]
      dest: "<%= files.glob.js.concatenated %>"

    spec:
      src: ["<%= files.glob.js.specHelpers %>", "<%= files.coffee.generatedSpecHelpers %>", "<%= files.glob.js.spec %>", "<%= files.coffee.generatedSpec %>"]
      dest: "<%= files.glob.js.concatenatedSpec %>"

    css:
      src: [
        "<%= files.less.generatedVendor %>",
        "<%= files.sass.generatedVendor %>",
        "<%= files.glob.css.vendor %>",
        "<%= files.less.generatedApp %>",
        "<%= files.sass.generatedApp %>",
        "<%= files.glob.css.app %>"
      ]
      dest: "<%= files.glob.css.concatenated %>"


  # notes: due to ../../ paths for images in many css libs we dump images out to the root of dist and generated
  #        if your lib requires a different structure to counter this, you'll need to nest your img files in vendor/img accordingly, ie: vendor/img/img
  images:
    files:
      "app/img/": "<%= files.glob.img.app %>"
      "vendor/img/": "<%= files.glob.img.vendor %>"

    root: "<%= files.glob.img.root %>"
    dev:
      dest: "generated"

    dist:
      dest: "dist"

  webfonts:
    files:
      "vendor/webfonts/": "<%= files.glob.webfonts.vendor %>"

    root: "<%= files.glob.webfonts.root %>"
    dev:
      dest: "generated"

    dist:
      dest: "dist"

  homepage:
    template: "app/templates/homepage.us"
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
    js:
      options:
        banner: "<%= meta.banner %>"
      files:
        "dist/js/app.min.js": "<%= files.glob.js.concatenated %>"

  cssmin:
    compress:
      files:
        "dist/css/app.min.css": "<%= files.glob.css.concatenated %>"


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
      files: ["<%= files.glob.js.vendor %>", "<%= files.glob.js.app %>"]
      tasks: ["concat:js"]

    coffee:
      files: "<%= files.glob.coffee.app %>"
      tasks: ["coffee", "concat:js"]

    jsSpecs:
      files: ["<%= files.glob.js.specHelpers %>", "<%= files.glob.js.spec %>"]
      tasks: ["concat:spec"]

    coffeeSpecs:
      files: ["<%= files.glob.coffee.specHelpers %>", "<%= files.glob.coffee.spec %>"]
      tasks: ["coffee", "concat:spec"]

    css:
      files: ["<%= files.glob.css.vendor %>", "<%= files.glob.css.app %>"]
      tasks: ["concat:css"]

    less:
      files: ["<%= files.glob.less.vendor %>", "<%= files.glob.less.app %>"]
      tasks: ["less", "concat:css"]

    sass:
      files: ["<%= files.glob.sass.vendor %>", "<%= files.glob.sass.app %>"]
      tasks: ["sass", "concat:css"]

    handlebars:
      files: "<%= files.glob.template.handlebars %>"
      tasks: ["handlebars", "concat:js"]

    underscore:
      files: "<%= files.glob.template.underscore %>"
      tasks: ["jst", "concat:js"]

    images:
      files: ["<%= files.glob.img.app %>", "<%= files.glob.img.vendor %>"]
      tasks: ["images:dev"]

    homepage:
      files: "<%= homepage.template %>"
      tasks: ["homepage:dev"]

    lint:
      files: "<%= files.glob.js.app %>"
      tasks: ["jshint"]

# Exports an object that defines
# *  all of the paths & globs that the project
# *  is concerned with.
# *
# * The "configure" task will require this file and
# *  then re-initialize the grunt config such that
# *  directives like <%= files.js.app %> will work
# *  regardless of the point you're at in the build
# *  lifecycle.
#
module.exports =
  dirs:
    app: "app"
    spec: "spec"
    vendor: "vendor"
    style: "css"
    script: "js"
    markup: "templates"
    images: "img"
    fonts: "webfonts"
    static: "pages"
    gen: "generated"
    dist: "dist"

  coffee:
    app: "<%= files.dirs.app %>/<%= files.dirs.script %>/**/*.coffee"
    spec: "<%= files.dirs.spec %>/**/*.coffee"
    specHelpers: "<%= files.dirs.spec %>/helpers/**/*.coffee"
    generated: "<%= files.dirs.gen %>/<%= files.dirs.script %>/app.coffee.js"
    generatedSpec: "<%= files.dirs.gen %>/<%= files.dirs.script %>/spec.coffee.js"
    generatedSpecHelpers: "<%= files.dirs.gen %>/<%= files.dirs.script %>/spec-helpers.coffee.js"

  js:
    app: "<%= files.dirs.app %>/<%= files.dirs.script %>/**/*.js"
    vendor: "<%= files.dirs.vendor %>/<%= files.dirs.script %>/**/*.js"
    spec: "<%= files.dirs.spec %>/**/*.js"
    specHelpers: "<%= files.dirs.spec %>/helpers/**/*.js"
    concatenated: "<%= files.dirs.gen %>/<%= files.dirs.script %>/app.js"
    concatenatedSpec: "<%= files.dirs.gen %>/<%= files.dirs.script %>/spec.js"
    minified: "<%= files.dirs.dist %>/<%= files.dirs.script %>/app.js"

  less:
    app: "<%= files.dirs.app %>/<%= files.dirs.style %>/**/*.less"
    vendor: "<%= files.dirs.vendor %>/<%= files.dirs.style %>/**/*.less"
    generatedApp: "<%= files.dirs.gen %>/<%= files.dirs.style %>/app.less.css"
    generatedVendor: "<%= files.dirs.gen %>/<%= files.dirs.style %>/vendor.less.css"

  sass:
    main: ["<%= files.dirs.app %>/<%= files.dirs.style %>/main.scss","<%= files.dirs.app %>/<%= files.dirs.style %>/main.sass"]
    app: ["<%= files.dirs.app %>/<%= files.dirs.style %>/**/*.scss", "<%= files.dirs.app %>/<%= files.dirs.style %>/**/*.sass"]
    vendor: ["<%= files.dirs.vendor %>/<%= files.dirs.style %>/**/*.scss", "<%= files.dirs.vendor %>/<%= files.dirs.style %>/**/*.sass"]
    generatedApp: "<%= files.dirs.gen %>/<%= files.dirs.style %>/app.sass.css"
    generatedVendor: "<%= files.dirs.gen %>/<%= files.dirs.style %>/vendor.sass.css"

  css:
    app: "<%= files.dirs.app %>/<%= files.dirs.style %>/**/*.css"
    vendor: "<%= files.dirs.vendor %>/<%= files.dirs.style %>/**/*.css"
    concatenated: "<%= files.dirs.gen %>/<%= files.dirs.style %>/app.css"
    minified: "<%= files.dirs.dist %>/<%= files.dirs.style %>/app.css"

  template:
    handlebars: ["<%= files.dirs.app %>/<%= files.dirs.markup %>/**/*.handlebar", "<%= files.dirs.app %>/<%= files.dirs.markup %>/**/*.handlebars", "<%= files.dirs.app %>/<%= files.dirs.markup %>/**/*.hb"]
    underscore: ["<%= files.dirs.app %>/<%= files.dirs.markup %>/**/*.underscore", "<%= files.dirs.app %>/<%= files.dirs.markup %>/**/*.us"]
    generatedHandlebars: "<%= files.dirs.gen %>/<%= files.dirs.markup %>/handlebars.js"
    generatedUnderscore: "<%= files.dirs.gen %>/<%= files.dirs.markup %>/underscore.js"
    generated: "<%= files.dirs.gen %>/<%= files.dirs.markup %>/**/*.js"

  pages:
    source: "<%= files.dirs.app %>/<%= files.dirs.static %>/**/*.*"

  img:
    app: "<%= files.dirs.app %>/<%= files.dirs.images %>/**/*.*"
    vendor: "<%= files.dirs.vendor %>/<%= files.dirs.images %>/**/*.*"
    root: "img"

  webfonts:
    vendor: "<%= files.dirs.vendor %>/<%= files.dirs.fonts %>/**/*.*"
    root: "webfonts"

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

  appDir: "app"
  specDir: "spec"
  vendorDir: "vendor"
  cssDir: "css"
  jsDir: "js"
  tmplDir: "templates"
  imgDir: "img"
  fontDir: "webfonts"
  staticDir: "pages"

  coffee:
    app: "<%= files.appDir %>/<%= files.jsDir %>/**/*.coffee"
    spec: "<%= files.specDir %>/**/*.coffee"
    specHelpers: "<%= files.specDir %>/helpers/**/*.coffee"
    generated: "generated/<%= files.jsDir %>/app.coffee.js"
    generatedSpec: "generated/<%= files.jsDir %>/spec.coffee.js"
    generatedSpecHelpers: "generated/<%= files.jsDir %>/spec-helpers.coffee.js"

  js:
    app: "<%= files.appDir %>/<%= files.jsDir %>/**/*.js"
    vendor: "<%= files.vendorDir %>/<%= files.jsDir %>/**/*.js"
    spec: "<%= files.specDir %>/**/*.js"
    specHelpers: "<%= files.specDir %>/helpers/**/*.js"
    concatenated: "generated/<%= files.jsDir %>/app.js"
    concatenatedSpec: "generated/<%= files.jsDir %>/spec.js"
    minified: "dist/<%= files.jsDir %>/app.js"

  less:
    app: "<%= files.appDir %>/<%= files.cssDir %>/**/*.less"
    vendor: "<%= files.vendorDir %>/<%= files.cssDir %>/**/*.less"
    generatedApp: "generated/<%= files.cssDir %>/app.less.css"
    generatedVendor: "generated/<%= files.cssDir %>/vendor.less.css"

  sass:
    main: ["<%= files.appDir %>/<%= files.cssDir %>/main.scss","<%= files.appDir %>/<%= files.cssDir %>/main.sass"]
    app: ["<%= files.appDir %>/<%= files.cssDir %>/**/*.scss", "<%= files.appDir %>/<%= files.cssDir %>/**/*.sass"]
    vendor: ["<%= files.vendorDir %>/<%= files.cssDir %>/**/*.scss", "<%= files.vendorDir %>/<%= files.cssDir %>/**/*.sass"]
    generatedApp: "generated/<%= files.cssDir %>/app.sass.css"
    generatedVendor: "generated/<%= files.cssDir %>/vendor.sass.css"

  css:
    app: "<%= files.appDir %>/<%= files.cssDir %>/**/*.css"
    vendor: "<%= files.vendorDir %>/<%= files.cssDir %>/**/*.css"
    concatenated: "generated/<%= files.cssDir %>/app.css"
    minified: "dist/<%= files.cssDir %>/app.css"

  template:
    handlebars: ["<%= files.appDir %>/<%= files.tmplDir %>/**/*.handlebar", "<%= files.appDir %>/<%= files.tmplDir %>/**/*.handlebars", "<%= files.appDir %>/<%= files.tmplDir %>/**/*.hb"]
    underscore: ["<%= files.appDir %>/<%= files.tmplDir %>/**/*.underscore", "<%= files.appDir %>/<%= files.tmplDir %>/**/*.us"]
    generatedHandlebars: "generated/<%= files.tmplDir %>/handlebars.js"
    generatedUnderscore: "generated/<%= files.tmplDir %>/underscore.js"
    generated: "generated/<%= files.tmplDir %>/**/*.js"

  pages:
    source: "<%= files.appDir %>/<%= files.staticDir %>/**/*.*"

  img:
    app: "<%= files.appDir %>/<%= files.imgDir %>/**/*.*"
    vendor: "<%= files.vendorDir %>/<%= files.imgDir %>/**/*.*"
    root: "img"

  webfonts:
    vendor: "<%= files.vendorDir %>/<%= files.fontDir %>/**/*.*"
    root: "webfonts"

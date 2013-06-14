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
  coffee:
    app: "app/js/**/*.coffee"
    spec: "spec/**/*.coffee"
    specHelpers: "spec/helpers/**/*.coffee"
    generated: "generated/js/app.coffee.js"
    generatedSpecHelpers: "generated/js/spec-helpers.coffee.js"
    generatedSpec: "generated/js/spec.coffee.js"

  js:
    vendor: "vendor/js/**/*.js"
    app: "app/js/**/*.js"
    spec: "spec/**/*.js"
    specHelpers: "spec/helpers/**/*.js"
    concatenated: "generated/js/app.js"
    concatenatedSpec: "generated/js/spec.js"
    minified: "dist/js/app.min.js"

  less:
    vendor: "vendor/css/**/*.less"
    app: "app/css/**/*.less"
    generatedVendor: "generated/css/vendor.less.css"
    generatedApp: "generated/css/app.less.css"

  sass:
    main: ["app/css/main.scss","app/css/main.sass"]
    vendor: ["vendor/css/**/*.scss", "vendor/css/**/*.sass"]
    app: ["app/css/**/*.scss", "app/css/**/*.sass"]
    generatedVendor: "generated/css/vendor.sass.css"
    generatedApp: "generated/css/app.sass.css"

  css:
    vendor: "vendor/css/**/*.css"
    app: "app/css/**/*.css"
    concatenated: "generated/css/app.css"

  template:
    homepage: "app/templates/homepage.us"
    handlebars: ["app/templates/**/*.handlebar", "app/templates/**/*.handlebars", "app/templates/**/*.hb"]
    underscore: ["app/templates/**/*.underscore", "app/templates/**/*.us"]
    generated: "generated/template/**/*.js"

  img:
    app: "app/img/**/*.*"
    vendor: "vendor/img/**/*.*"
    root: "img"

  webfonts:
    vendor: "vendor/webfonts/**/*.*"
    root: "webfonts"

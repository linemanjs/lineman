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
    generatedSpec: "generated/js/spec.coffee.js"
    generatedSpecHelpers: "generated/js/spec-helpers.coffee.js"

  js:
    app: "app/js/**/*.js"
    vendor: "vendor/js/**/*.js"
    spec: "spec/**/*.js"
    specHelpers: "spec/helpers/**/*.js"
    concatenated: "generated/js/app.js"
    concatenatedSpec: "generated/js/spec.js"
    minified: "dist/js/app.js"
    minifiedWebRelative: "js/app.js"

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
    minified: "dist/css/app.css"
    minifiedWebRelative: "css/app.css"

  template:
    handlebars: "app/templates/**/*.{hb,hbs,handlebar,handlebars}"
    underscore: ["app/templates/**/*.underscore", "app/templates/**/*.us"]
    generatedHandlebars: "generated/template/handlebars.js"
    generatedUnderscore: "generated/template/underscore.js"
    generated: "generated/template/**/*.js"

  pages:
    source: "app/pages/**/*.*"

  img:
    app: "app/img/**/*.*"
    vendor: "vendor/img/**/*.*"
    root: "img"

  webfonts:
    vendor: "vendor/webfonts/**/*.*"
    root: "webfonts"

  assetFingerprint:
    manifest: "dist/assets.json"
    textFiles: ["dist/**/*.{js,css,html,xml}"]

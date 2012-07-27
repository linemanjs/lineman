/* Exports an object that defines
 *  all of the paths & globs that the project
 *  is concerned with.
 *
 * The "configure" task will require this file and
 *  then re-initialize the grunt config such that
 *  directives like <config:files.js.app> will work
 *  regardless of the point you're at in the build
 *  lifecycle.
 */

module.exports = {
  coffee: {
    app: "app/js/**/*.coffee",
    spec: "spec/js/**/*.coffee",
    specHelpers: "spec/helpers/**/*.coffee",
    generated: "generated/js/app.coffee.js",
    generatedSpecHelpers: "generated/js/spec-helpers.coffee.js",
    generatedSpec: "generated/js/spec.coffee.js"
  },
  js: {
    vendor: "vendor/js/**/*.js",
    app: "app/js/**/*.js",
    spec: "spec/**/*.js",
    specHelpers: "spec/helpers/**/*.js",
    concatenated: "generated/js/app.js",
    concatenatedSpec: "generated/js/spec.js",
    minified: "dist/js/app.min.js"
  },

  less: {
    app: "app/css/**/*.less",
    generated: "generated/css/app.less.css"
  },
  css: {
    vendor: "vendor/css/**/*.css",
    app: "app/css/**/*.css",
    concatenated: "generated/css/app.css"
  },

  template: {
    handlebars: ["app/templates/**/*.handlebar", "app/templates/**/*.handlebars", "app/templates/**/*.hb"],
    underscore: ["app/templates/**/*.underscore", "app/templates/**/*.us"],
    generated: "generated/template/**/*.js"
  },

  img: {
    app: "app/img/**/*.*",
    vendor: "vendor/img/**/*.*"
  }
};
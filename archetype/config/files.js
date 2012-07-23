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
  editable: {
    app: "app/**/*.*",
    spec: "spec/**/*.*",
    vendor: "vendor/**/*.*"
  },

  coffee: {
    app: "app/js/**/*.coffee",
    spec: "spec/js/**/*.coffee",
    generated: "generated/js/app.coffee.js"
  },
  js: {
    vendor: "vendor/js/**/*.js",
    app: "app/js/**/*.js",
    spec: ["spec/js/**/*.js", "generated/js/spec.coffee.js"]
  },

  less: {
    app: "app/css/**/*.less",
    generated: "generated/css/app.less.css"
  },
  css: {
    vendor: "vendor/css/**/*.css",
    app: "app/css/**/*.css"
  },

  template: {
    handlebars: "app/templates/**/*.handlebar",
    underscore: "app/templates/**/*.us",
    generated: "generated/template/**/*.js"
  },

  img: {
    app: "app/img/**/*",
    vendor: "vendor/img/**/*"
  }
};
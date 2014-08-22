module.exports = (lineman) ->
  config:
    watch:
      options:
        spawn: false
        module: "grunt-watch-nospawn"

      js:
        files: ["<%= files.js.vendor %>", "<%= files.js.app %>"]
        tasks: ["concat_sourcemap:js"]

      coffee:
        files: "<%= files.coffee.app %>"
        tasks: ["coffee", "concat_sourcemap:js"]

      jsSpecs:
        files: ["<%= files.js.specHelpers %>", "<%= files.js.spec %>"]
        tasks: ["concat_sourcemap:spec"]

      coffeeSpecs:
        files: ["<%= files.coffee.specHelpers %>", "<%= files.coffee.spec %>"]
        tasks: ["coffee", "concat_sourcemap:spec"]

      css:
        files: ["<%= files.css.vendor %>", "<%= files.css.app %>"]
        tasks: ["concat_sourcemap:css"]

      less:
        files: ["app/css/**/*.less", "vendor/css/**/*.less"]
        tasks: ["learnAboutLinemanPlugin:lineman-less"]

      sass:
        files: ["<%= files.sass.vendor %>", "<%= files.sass.app %>"]
        tasks: ["sass", "concat_sourcemap:css"]

      pages:
        files: ["<%= files.pages.source %>", "app/templates/homepage.us"]
        tasks: ["pages:dev"]

      handlebars:
        files: "<%= files.template.handlebars %>"
        tasks: ["handlebars", "concat_sourcemap:js"]

      underscore:
        files: "<%= files.template.underscore %>"
        tasks: ["jst", "concat_sourcemap:js"]

      images:
        files: ["<%= files.img.app %>", "<%= files.img.vendor %>"]
        tasks: ["images:dev"]

      lint:
        files: "<%= files.js.app %>"
        tasks: ["jshint"]

      webfonts:
        files: "<%= files.webfonts.vendor %>"
        tasks: ["webfonts:dev"]

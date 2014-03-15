module.exports = (lineman) ->
  config:
    concat_sourcemap:
      options:
        sourcesContent: true

      js:
        src: [
          "<%= files.js.vendor %>"
          "<%= files.template.generated %>"
          "<%= files.js.app %>"
          "<%= files.coffee.generated %>"
        ]
        dest: "<%= files.js.concatenated %>"

      spec:
        src: [
          "<%= files.js.specHelpers %>"
          "<%= files.coffee.generatedSpecHelpers %>"
          "<%= files.js.spec %>"
          "<%= files.coffee.generatedSpec %>"
        ]
        dest: "<%= files.js.concatenatedSpec %>"

      css:
        src: [
          "<%= files.sass.generatedVendor %>"
          "<%= files.css.vendor %>"
          "<%= files.sass.generatedApp %>"
          "<%= files.css.app %>"
        ]
        dest: "<%= files.css.concatenated %>"

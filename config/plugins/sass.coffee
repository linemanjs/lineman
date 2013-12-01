module.exports = (lineman) ->
  config:
    sass:
      compile:
        options:
          loadPath: ["app/css", "vendor/css"]
        files:
          "<%= files.sass.generatedApp %>": "<%= files.sass.main %>"

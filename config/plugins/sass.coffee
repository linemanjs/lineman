module.exports = (lineman) ->
  config:
    sass:
      compile:
        options:
          excludeRubyOptions: ['includePaths']
          loadPath: ["app/css", "vendor/css"]
          includePaths: ["app/css", "vendor/css"]
        files:
          "<%= files.sass.generatedApp %>": "<%= files.sass.main %>"

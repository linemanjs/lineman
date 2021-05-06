sass = require("sass")

module.exports = (lineman) ->
  config:
    sass:
      compile:
        options:
          implementation: sass
          loadPath: ["app/css", "vendor/css"]
          includePaths: ["app/css", "vendor/css"]
        files:
          "<%= files.sass.generatedApp %>": "<%= files.sass.main %>"

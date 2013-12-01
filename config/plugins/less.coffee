module.exports = (lineman) ->
  config:
    less:
      options:
        paths: ["app/css", "vendor/css"]
      compile:
        files:
          "<%= files.less.generatedVendor %>": "<%= files.less.vendor %>"
          "<%= files.less.generatedApp %>": "<%= files.less.app %>"

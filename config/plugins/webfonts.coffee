module.exports = (lineman) ->
  config:
    webfonts:
      files:
        "vendor/webfonts/": "<%= files.webfonts.vendor %>"

      root: "<%= files.webfonts.root %>"
      dev:
        dest: "generated"

      dist:
        dest: "dist"

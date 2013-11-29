module.exports = (lineman) ->
  config:
    files:
      "vendor/webfonts/": "<%= files.webfonts.vendor %>"

    root: "<%= files.webfonts.root %>"
    dev:
      dest: "generated"

    dist:
      dest: "dist"

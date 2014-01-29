module.exports = (lineman) ->
  config:
    assetFingerprint:
      options:
        manifestPath: "<%= files.assetFingerprint.manifest %>"
        findAndReplaceFiles: "<%= files.assetFingerprint.textFiles %>"
        keepOriginalFiles: false

      dist:
        files: [
          expand: true
          cwd: "dist"
          src: [
            "<%= files.img.root %>/**/*",
            "<%= files.webfonts.root %>/**/*",
            "<%= files.js.minifiedWebRelative %>",
            "<%= files.css.minifiedWebRelative %>"
          ]
          dest: "dist"
        ]

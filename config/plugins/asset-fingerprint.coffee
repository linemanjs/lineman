module.exports = (lineman) ->
  config:
    options:
      manifestPath: "<%= files.assetFingerprint.manifest %>"

    dist:
      files: [
        expand: true
        cwd: "dist"
        src: ["<%= files.js.minifiedWebRelative %>", "<%= files.css.minifiedWebRelative %>"]
        dest: "dist"
      ]

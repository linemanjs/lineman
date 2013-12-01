module.exports = (lineman) ->
  config:
    uglify:
      options:
        banner: "<%= meta.banner %>"
      js:
        files:
          "<%= files.js.minified %>": "<%= files.js.concatenated %>"

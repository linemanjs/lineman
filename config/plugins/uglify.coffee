module.exports = (lineman) ->
  config:
    options:
      banner: "<%= meta.banner %>"
    js:
      files:
        "<%= files.js.minified %>": "<%= files.js.concatenated %>"

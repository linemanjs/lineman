module.exports = (lineman) ->
  config:
    compress:
      files:
        "<%= files.css.minified %>": "<%= files.css.concatenated %>"

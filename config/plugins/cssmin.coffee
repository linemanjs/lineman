module.exports = (lineman) ->
  config:
    cssmin:
      compress:
        files:
          "<%= files.css.minified %>": "<%= files.css.concatenated %>"

module.exports = (lineman) ->
  config:
    clean:
      js:
        src: "<%= files.js.concatenated %>"

      css:
        src: "<%= files.css.concatenated %>"

      dist:
        src: ["dist", "generated"]

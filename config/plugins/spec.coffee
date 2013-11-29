module.exports = (lineman) ->
  config:
    files: ["<%= files.js.concatenated %>", "<%= files.js.concatenatedSpec %>"]
    options:
      growl: false

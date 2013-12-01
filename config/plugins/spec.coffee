module.exports = (lineman) ->
  config:
    spec:
      files: ["<%= files.js.concatenated %>", "<%= files.js.concatenatedSpec %>"]
      options:
        growl: false

module.exports = (lineman) ->
  config:
    compile:
      files:
        "<%= files.template.generatedUnderscore %>": "<%= files.template.underscore %>"

module.exports = (lineman) ->
  config:
    jst:
      compile:
        files:
          "<%= files.template.generatedUnderscore %>": "<%= files.template.underscore %>"

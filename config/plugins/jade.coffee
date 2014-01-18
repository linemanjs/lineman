module.exports = (lineman) ->
  config:
    jade:
      compile:
        files:
          "<%= files.template.generatedJade %>": "<%= files.template.jade %>"

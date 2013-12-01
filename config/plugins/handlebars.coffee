module.exports = (lineman) ->
  config:
    handlebars:
      compile:
        files:
          "<%= files.template.generatedHandlebars %>": "<%= files.template.handlebars %>"

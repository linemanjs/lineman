module.exports = (lineman) ->
  config:
    compile:
      files:
        "<%= files.template.generatedHandlebars %>": "<%= files.template.handlebars %>"

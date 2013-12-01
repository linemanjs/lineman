module.exports = (lineman) ->
  config:
    coffee:
      compile:
        files:
          "<%= files.coffee.generated %>": "<%= files.coffee.app %>"
          "<%= files.coffee.generatedSpec %>": "<%= files.coffee.spec %>"
          "<%= files.coffee.generatedSpecHelpers %>": "<%= files.coffee.specHelpers %>"

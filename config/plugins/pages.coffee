module.exports = (lineman) ->
  config:
    pages:
      dev:
        files:
          "generated": "<%= files.pages.source %>",
          "generated/index.html": "app/templates/homepage.*" # backward compatibility
        context:
          js: "js/app.js"
          css: "css/app.css"
      dist:
        files:
          "dist": "<%= files.pages.source %>",
          "dist/index.html": "app/templates/homepage.*" # backward compatibility
        context:
          js: "js/app.js"
          css: "css/app.css"

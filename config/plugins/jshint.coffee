module.exports = (lineman) ->
  config:
    jshint:
      files: ["<%= files.js.app %>"]
      options:
        # enforcing options
        curly: true
        eqeqeq: true
        latedef: true
        newcap: true
        noarg: true
        # relaxing options
        boss: true
        eqnull: true
        sub: true
        # environment/globals
        browser: true
        # Toggle on support for recent JavaScript
        esversion: 6

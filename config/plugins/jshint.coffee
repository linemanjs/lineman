module.exports = (lineman) ->
  config:
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

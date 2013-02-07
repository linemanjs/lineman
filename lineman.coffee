extend = require("whet.extend")
module.exports =
  config:
    application: require("./config/application")
    files: require("./config/files")
    grunt: require("./config/grunt")
    extend: (key, stuff) ->
      extend(true, {}, module.exports.config[key], stuff)

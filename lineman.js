require('coffee-script');
var extend = require("whet.extend");

module.exports = {
  config: {
    application: require(__dirname+"/config/application"),
    files: require(__dirname+"/config/files"),
    grunt: require(__dirname+"/config/grunt"),
    extend: function(key, stuff) {
      return extend(true, {}, module.exports.config[key], stuff);
    }
  },
  version: require(__dirname+"/package").version
};

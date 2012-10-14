var extend = require('whet.extend');

module.exports = {
  config: {
    application: require(__dirname + "/config/application.js"),
    files: require(__dirname + "/config/files.js"),
    grunt: require(__dirname + "/config/grunt.js"),
    extend: function(key, stuff) {
      return extend(true, {}, module.exports.config[key], stuff);
    }
  }
};
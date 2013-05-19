require('coffee-script');

module.exports = {
  config: {
    application: require(__dirname+"/config/application"),
    files: require(__dirname+"/config/files"),
    grunt: require(__dirname+"/config/grunt"),
    extend: require(__dirname+"/lib/extend")
  },
  version: require(__dirname+"/package").version
};

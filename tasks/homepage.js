/**
 * Task: homepage
 * Description: copies a home page html file for the project dist directory
 * Dependencies: grunt, fs
 * Contributor: @searls
 *
 * options:
 *  template - [required] path to the homepage template file
 *  format - [optional] type of the template (if not provided, the file extension will be used)
 *
 * Supported formats:
 *  html - template will merely be copied
 *  underscore (aliases: "us", "jst") - underscore templating
 *  handlebar (aliases: "hb", "handlebars") - handlebars templating
 *
 * When the template is processed, it will be passed the grunt configuration object,
 *   which contains lots of useful goodies.
 */

module.exports = function(grunt) {
  var fs = require('fs'), _ = grunt.utils._;

  var extensionOf = function(fileName) {
    return _(fileName.match(/[^.]*$/)).last();
  };

  grunt.registerTask('homepage', 'generates a home page html file for the project dist directory', function(target){
    target = target || "dist";

    this.requiresConfig('homepage.template');
    this.requiresConfig('homepage.'+target);

    var template = grunt.config.get('homepage.template'),
        targetConfig = grunt.config.get('homepage.'+target),
        format = (grunt.config.get('homepage.format') || extensionOf(template) || "html").toLowerCase();

    if(format === "html") {
      grunt.file.copy(template, targetConfig.dest);
    } else {
      var source = grunt.file.read(template),
          context = _(grunt.config.get()).extend(targetConfig.context),
          html;
      if(_(["underscore", "us", "jst"]).include(format)) {
        html = _(source).template()(context);
      } else if(_(["handlebar", "hb", "handlebars"]).include(format)) {
        html = require("handlebars").compile(source)(context);
      }

      grunt.file.write(targetConfig.dest, html);
    }

    grunt.log.writeln("Homepage HTML written to '"+targetConfig.dest+"'")
  });
};
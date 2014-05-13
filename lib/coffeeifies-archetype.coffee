grunt = require('./requires-grunt').require()
_ = require("lodash")
js2coffee = require('js2coffee')

module.exports =
  coffeeify: (dest) ->
    _(grunt.file.expand([
      "#{dest}/**/*.js",
      "!#{dest}/spec/helpers/**/*.js",
      "!#{dest}/vendor/js/**/*.js"
    ])).each (f) ->
      coffee = js2coffee.build(grunt.file.read(f)).
        replace(/# \*/g, '# '). #<-- remove extra asterisks in block comments
        replace(/\s*return\n/g,''). #<-- remove un-implicitification of returns
        replace(/(Given|When|Then)( ->)\n\s*/g, '$1$2 ') #<-- one-line-ify example specs

      grunt.file.delete(f)
      grunt.file.write(f.replace(/\.js$/, ".coffee"), coffee, encoding: "utf8")

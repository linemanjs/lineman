# Synchronous file helpers
grunt = require("grunt")
fs = require("fs")
module.exports = ((_, fs, grunt) ->
  _({}).tap (exports) ->
    exports.copy = (src, dest) ->
      file = fs.lstatSync(src)
      if file.isDirectory()
        exports.copyDir src, dest
      else
        grunt.file.copy src, dest


    # grunt.log.writeln("Copied image '"+src+"' to '"+dest+"'");
    exports.copyDir = (src, dest) ->
      mkdirIfNecessary src, dest
      paths = fs.readdirSync(src)
      _(paths).each (path) ->
        exports.copy src + "/" + path, dest + "/" + path


    exports.loadConfigurationFile = (name) ->

      #TODO: I don't like using try/catch for flow control but
      #  fs.existSync != require's ability to find modules, b/c require
      #  supports multiple extension lookup.
      try
        return require(process.cwd() + "/config/" + name)
      catch e
        if e.code is "MODULE_NOT_FOUND"
          return {}
        else
          throw e

    exports.overwritePackageJson = (src, name) ->
      linemanPackageJson = grunt.file.readJSON(__dirname + "/../package.json")
      newPackageJson = _(grunt.file.read(src)).template(
        name: _(name).dasherize()
        versions:
          lineman: "~" + linemanPackageJson["version"]
          testem: linemanPackageJson["dependencies"]["testem"]
      )
      grunt.file.write src, newPackageJson

    mkdirIfNecessary = (src, dest) ->
      checkDir = fs.statSync(src)
      try
        fs.mkdirSync dest, checkDir.mode
      catch e
        throw e  if e.code isnt "EEXIST"

)(grunt.util._, fs, grunt)

# Synchronous file helpers
grunt = require('./requires-grunt').require()
_ = require("lodash")
_str = require("underscore.string")
fs = require("fs")

module.exports = fileUtils =
  copy: (src, dest) ->
    file = fs.lstatSync(src)
    if file.isDirectory()
      fileUtils.copyDir(src, dest)
    else
      grunt.file.copy(src, dest)

  copyDir: (src, dest) ->
    mkdirIfNecessary(src, dest)
    paths = fs.readdirSync(src)
    _(paths).each (path) ->
      fileUtils.copy("#{src}/#{path}", "#{dest}/#{path}")

  loadConfigurationFile: (name) ->
    #TODO: I don't like using try/catch for flow control but
    #  fs.existSync != require's ability to find modules, b/c require
    #  supports multiple extension lookup.
    try
      return require(configurationFileForName(name))
    catch e
      if e.code == "MODULE_NOT_FOUND"
        return {}
      else
        throw e

  reloadConfigurationFile: (name) ->
    configName = configurationFileForName(name)
    _(require.cache).each (entry, path) ->
      if path.indexOf(configName) == 0
        delete require.cache[path]
    fileUtils.loadConfigurationFile(name)

  overwritePackageJson: (src, name) ->
    linemanPackageJson = grunt.file.readJSON("#{__dirname}/../package.json")
    newPackageJson = _(grunt.file.read(src)).template(
      name: _str.dasherize(name)
      versions:
        lineman: "~" + linemanPackageJson["version"]
    )
    grunt.file.write(src, newPackageJson)

mkdirIfNecessary = (src, dest) ->
  checkDir = fs.statSync(src)
  try
    fs.mkdirSync(dest, checkDir.mode)
  catch e
    throw e  if e.code != "EEXIST"

configurationFileForName = (name) -> "#{process.cwd()}/config/#{name}"

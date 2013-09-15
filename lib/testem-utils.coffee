fs = require("fs")

module.exports =
  testemRunnerPath: ->
    testemPath = "node_modules/.bin/testem"
    extension = if require('os').platform() == "win32" then ".cmd" else ""
    localPath = "#{process.cwd()}/#{testemPath}#{extension}"
    linemanPath = "#{__dirname}/../#{testemPath}#{extension}"
    if fs.existsSync(localPath)
      localPath
    else if fs.existsSync(linemanPath)
      linemanPath
    else
      throw "Testem runner wasn't found! Make sure it is installed locally to your project or under `node_modules/lineman`"

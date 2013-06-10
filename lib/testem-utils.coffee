fs = require("fs")

module.exports =
  testemRunnerPath: ->
    testemPath = "node_modules/.bin/testem"
    localPath = "#{process.cwd()}/#{testemPath}"
    linemanPath = "#{__dirname}/../#{testemPath}"
    if fs.existsSync(localPath)
      localPath
    else if fs.existsSync(linemanPath)
      linemanPath
    else
      throw "Testem runner wasn't found! Make sure it is installed locally to your project or under `node_modules/lineman`"

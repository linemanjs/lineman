###
Task: spec-ci
Description: run specs in ci mode
Dependencies: grunt
Contributor: @davemo
###

findsForwardedArgs = require("./../lib/finds-forwarded-args")

getRandomPort = ->
  server = require('net').createServer()
  port = server.listen(0).address().port
  server.close()
  port

module.exports = (grunt) ->
  path = require("path")
  spawn = require("child_process").spawn
  fs = require("fs")
  testemRunnerPath = require("./../lib/testem-utils").testemRunnerPath

  grunt.registerTask "spec-ci", "run specs in ci mode", (target) ->
    try
      done = @async()
      args = [
        "ci",
        "-f", path.resolve("#{process.cwd()}/config/spec.json"),
        "-p", getRandomPort()
      ].concat(findsForwardedArgs.find())
      if this.options().reporter
        args.push "-R"
        args.push this.options().reporter
      child = spawn(testemRunnerPath(), args)

      child.stdout.on "data", (data) =>
        console.log String(data)
        if this.options().reporterOutput
          outdir = path.dirname(this.options().reporterOutput)
          unless fs.existsSync(outdir)
            fs.mkdirSync(outdir)
          fs.writeFileSync(this.options().reporterOutput, data, 'utf-8')

      child.on "exit", (code, signal) ->
        if code != 0
          grunt.warn("Spec execution appears to have failed.")
          done(false)
        else
          done()
    catch e
      grunt.fatal(e)
      throw e

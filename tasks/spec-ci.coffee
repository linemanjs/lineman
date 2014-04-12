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
  testemRunnerPath = require("./../lib/testem-utils").testemRunnerPath

  grunt.registerTask "spec-ci", "run specs in ci mode", (target) ->
    reporter = @options(reporter: {}).reporter

    try
      done = @async()
      args = [
        "ci",
        "-f", path.resolve("#{process.cwd()}/config/spec.json"),
        "-p", getRandomPort()
      ].concat(findsForwardedArgs.find())
      args.push("-R", reporter.type) if reporter.type?

      child = spawn(testemRunnerPath(), args)

      output = ""
      child.stdout.on "data", (data) =>
        process.stdout.write(chunk = data.toString())
        output += chunk

      child.on "exit", (code, signal) ->
        writeReport(output, reporter.dest)
        if code != 0
          grunt.warn("Spec execution appears to have failed.")
          done(false)
        else
          done()
    catch e
      grunt.fatal(e)
      throw e

  writeReport = (report, dest) ->
    return unless dest?
    grunt.file.mkdir(path.dirname(dest))
    grunt.file.write(dest, report, encoding: 'utf-8')
    grunt.log.writeln("Wrote spec-ci report results to `#{dest}`")


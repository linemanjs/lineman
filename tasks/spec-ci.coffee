###
Task: spec-ci
Description: run specs in ci mode
Dependencies: grunt
Contributor: @davemo
###
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
    try
      done = @async()
      args = [
        "ci",
        "-f", path.resolve("#{process.cwd()}/config/spec.json"),
        "-p", getRandomPort()
      ]
      options = { stdio: 'inherit'}
      child = spawn(testemRunnerPath(), args, options)

      child.on "exit", (code, signal) ->
        if code != 0
          grunt.warn("Spec execution appears to have failed.")
          done(false)
        else
          done()
    catch e
      grunt.fatal(e)
      throw e

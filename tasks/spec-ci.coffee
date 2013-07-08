###
Task: spec-ci
Description: run specs in ci mode
Dependencies: grunt
Contributor: @davemo
###
module.exports = (grunt) ->
  path = require("path")
  spawn = require("child_process").spawn
  testemRunnerPath = require("./../lib/testem-utils").testemRunnerPath

  grunt.registerTask "spec-ci", "run specs in ci mode", (target) ->
    try
      done = @async()
      args = ["ci", "-f", path.resolve("#{process.cwd()}/config/spec.json")]
      child = spawn(testemRunnerPath(), args)
      output = ""
      child.stdout.on "data", (chunk) ->
        process.stdout.write(chunk)
        output += chunk

      child.on "exit", (code, signal) ->
        debugger
        if code != 0
          grunt.warn("Spec execution appears to have failed.")
          done(false)
        else
          done()
    catch e
      grunt.fatal(e)
      throw e

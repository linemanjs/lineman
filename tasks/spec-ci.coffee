###
Task: spec-ci
Description: run specs in ci mode
Dependencies: grunt
Contributor: @davemo
###
module.exports = (grunt) ->
  _ = grunt.util._
  path = require("path")
  spawn = require("child_process").spawn
  grunt.registerTask "spec-ci", "run specs in ci mode", (target) ->
    done = @async()
    args = ["ci", "-f", path.resolve(process.cwd() + "/config/spec.json")]
    child = spawn(process.cwd() + "/node_modules/testem/testem.js", args)
    output = ""
    child.stdout.on "data", (chunk) ->
      process.stdout.write chunk
      output += chunk

    child.on "exit", (code, signal) ->
      if code isnt 0 or testsFailed(output)
        grunt.warn "Spec execution appears to have failed."
        done false
      else
        done()



testsFailed = (output) ->
  lines = output.split("\n")
  summaryLine = lines[lines.length - 2]
  summaryLine isnt "# ok"

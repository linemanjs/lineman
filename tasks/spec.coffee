###
Task: spec
Description: run specs
Dependencies: grunt
Contributor: @searls
###
module.exports = (grunt) ->
  path = require("path")
  fork = require("child_process").fork
  testemRunnerPath = require("./../lib/testem-utils").testemRunnerPath

  grunt.registerTask "spec", "run specs", (target) ->
    done = @async()
    args = ["-f", path.resolve("#{process.cwd()}/config/spec.json")]
    if this.options().growl then args.push "-g"
    child = fork(testemRunnerPath(), args)
    child.on "exit", (code, signal) ->
      grunt.warn("Spec execution failed with exit code #{code}")  if code != 0
      done()

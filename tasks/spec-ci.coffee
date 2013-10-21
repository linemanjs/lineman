###
Task: spec-ci
Description: run specs in ci mode
Dependencies: grunt
Contributor: @davemo
###

module.exports = (grunt) ->

  spawn = require("child_process").spawn
  testemRunnerPath = require("./../lib/testem-utils").testemRunnerPath
  exposedTestemOptionDefaults = require("./../lib/testem-utils").exposedTestemOptionDefaults()
  _ = grunt.util._

  grunt.registerTask "spec-ci", "run specs in ci mode", ->

    testemFlags =
      "-R"     : grunt.config.get("spec_ci.reporter") || exposedTestemOptionDefaults.reporter
      "-f"     : grunt.config.get("spec_ci.config")   || exposedTestemOptionDefaults.config
      "-p"     : grunt.config.get("spec_ci.port")     || exposedTestemOptionDefaults.port
      "--host" : grunt.config.get("spec_ci.host")     || exposedTestemOptionDefaults.host

    args = _(testemFlags).chain()
      .pairs()
      .union(["ci"])
      .flatten()
      .value()

    try
      done = @async()
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

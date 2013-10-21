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

    testemOptions = _({}).merge exposedTestemOptionDefaults,
      reporter: grunt.config.get("spec_ci.reporter")
      config:   grunt.config.get("spec_ci.config")
      port:     grunt.config.get("spec_ci.port")
      host:     grunt.config.get("spec_ci.host")

    testemFlags =
      "-R"     : testemOptions.reporter
      "-f"     : testemOptions.config
      "-p"     : testemOptions.port
      "--host" : testemOptions.host

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

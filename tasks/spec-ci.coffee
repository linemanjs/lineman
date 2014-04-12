###
Task: spec-ci
Description: run specs in ci mode
Dependencies: grunt
Contributor: @davemo
###

_ = require("lodash")
path = require("path")
net = require('net')
spawn = require("child_process").spawn
testemRunnerPath = require("./../lib/testem-utils").testemRunnerPath
findsForwardedArgs = require("./../lib/finds-forwarded-args")
AccumulatesStreams = require("./../lib/accumulates-streams")

module.exports = (grunt) ->

  grunt.registerTask "spec-ci", "run specs in ci mode", (target) ->
    reporter = @options(reporter: {}).reporter

    try
      done = @async()
      args = _(["ci"]).chain().
        concat("-f", path.resolve("#{process.cwd()}/config/spec.json")).
        concat("-p", getRandomPort()).
        concat(findsForwardedArgs.find()).
        concat(["-R", reporter.type] if reporter.type?).
        compact().value()

      grunt.log.writeln("Will write spec-ci report results to `#{reporter.dest}`") if reporter.dest?

      child = spawn(testemRunnerPath(), args)
      stdout = new AccumulatesStreams(child.stdout).accumulate()
      child.on "exit", (code, signal) ->
        writeReport(stdout.getValue(), reporter.dest)
        if code != 0
          grunt.warn("Spec execution appears to have failed.")
          done(false)
        else
          done()
    catch e
      grunt.fatal(e)
      throw e

  getRandomPort = ->
    _((server = net.createServer()).listen(0).address().port).tap -> server.close()

  writeReport = (report, dest) ->
    return unless dest?
    grunt.file.mkdir(path.dirname(dest))
    grunt.file.write(dest, report, encoding: 'utf-8')

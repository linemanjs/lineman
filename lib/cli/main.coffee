commander = require("commander")
grunt = require("grunt")
cli = require("grunt/lib/grunt/cli")
packageJson = require("./../../package")
_ = grunt.util._

module.exports = ->
  require("./setup-env")()

  commander.version(packageJson.version)

  require("./setup-options")(commander, cli)

  require("./ensure-appropriate-version")()

  commander.
    command("new").
    description(" - generates a new lineman project in the specified folder : lineman new my-project").
    action (projectName) ->
      require('./lineman-new')(projectName, commander.install, commander.skipExamples)

  commander.
    command("run").
    description(" - runs the development server from /generated and watches files for updates").
    action (context) ->
      process.env["LINEMAN_RUN"] = true
      cli.options.force = true unless cli.options.stack?
      cli.tasks = ["common", "dev"]
      grunt.cli()

  commander.
    command("build").
    description(" - compiles all assets into a production ready form in the /dist folder").
    action ->
      cli.tasks = ["common", "dist"]
      grunt.cli()

  commander.
    command("spec").
    description(" - runs specs in Chrome, override in config/spec.json").
    action ->
      cli.tasks = ["spec"]
      grunt.cli()

  commander.
    command("spec-ci").
    description(" - runs specs in a single pass using PhantomJS (which must be on your PATH) and outputs in TAP13 format, override in config/spec.json").
    action ->
      cli.tasks = ["common", "spec-ci"]
      grunt.cli()

  commander.
    command("clean").
    description(" - cleans out /generated and /dist folders").
    action ->
      cli.tasks = ["clean"]
      grunt.cli()

  commander.
    command("grunt").
    description("Run a grunt command with lineman's version of grunt").
    action ->
      cli.options.base = process.cwd()
      cli.tasks = grunt.util._(arguments).chain().toArray().initial().without("grunt").value()
      grunt.cli(gruntfile: (__dirname + "/../../Gruntfile.coffee"))

  commander.command("*").description("unknown command").action ->
    commander.help()

  commander.parse(process.argv)

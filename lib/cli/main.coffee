commander = require("commander")
path = require("path")
requiresGrunt = require('./../requires-grunt')
grunt = requiresGrunt.require()
cli = require(path.join(requiresGrunt.whereIsGrunt(), "lib", "grunt", "cli"))
packageJson = require("./../../package")
RunsNextCommand = require("./runs-next-command")
ReadsConfiguration = require("./../reads-configuration")
prettyPrintsValue = require("./../pretty-prints-value")

_ = require("lodash")

module.exports = ->
  require("./setup-env")()

  commander.version(packageJson.version)

  require("./setup-options")(commander, cli)

  require("./ensure-appropriate-version")()

  commander.
    command("new").
    description(" - generates a new lineman project in the specified folder : lineman new my-project").
    action (projectName) ->
      require('./lineman-new')(projectName, commander.install, commander.skipExamples, commander.coffee)

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
      cli.tasks = if commander.skipClean
        ["common", "dist"]
      else
        ["clean", "common", "dist"]
      invokeGrunt(name: "build", chainable: true)

  commander.
    command("spec").
    description(" - runs specs in Chrome, override in config/spec.json").
    action ->
      cli.tasks = ["spec"]
      invokeGrunt()

  commander.
    command("spec-ci").
    description(" - runs specs in a single pass using PhantomJS (which must be on your PATH) and outputs in TAP13 format, override in config/spec.json").
    action ->
      cli.tasks = ["common", "spec-ci"]
      invokeGrunt(name: "spec-ci", chainable: true)

  commander.
    command("config").
    description(" - get a value from lineman's configuration").
    action ->
      configPropertyPath = if _(@args[0]).isString() then @args[0] else undefined
      value = new ReadsConfiguration().read(configPropertyPath, commander.process)
      console.log(prettyPrintsValue.prettyPrint(value))

  commander.
    command("clean").
    description(" - cleans out /generated and /dist folders").
    action ->
      cli.tasks = ["clean"]
      invokeGrunt(name: "clean", chainable: true)

  commander.
    command("grunt").
    description("Run a grunt command with lineman's version of grunt").
    action ->
      cli.options.base = process.cwd()
      cli.tasks = _(arguments).chain().toArray().initial().without("grunt").value()
      invokeGrunt
        options:
          gruntfile: "#{__dirname}/../../Gruntfile.coffee"

  commander.
    command('fetch').
    description("Fetch a library and add it to your Lineman project").
    action ->
      recipes = _(@args).filter(_.isString)
      require('./lineman-fetch')(recipes)



  process.argv[2] = "help" if noCommandWasGiven()

  commander.command("*").description("unknown command").action ->
    commander.help()

  commander.parse(process.argv)

invokeGrunt = (config = {}) ->
  done = new RunsNextCommand(commander, config.name).run if config.chainable?
  grunt.cli(config.options || {}, done)

noCommandWasGiven = -> _(process.argv[2]).isEmpty()

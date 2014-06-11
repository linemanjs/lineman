# This thing is somewhat disgusting. Best that I use an example to explain:
#   Suppose the user enters "lineman clean run"
#   This means when the `clean` action runs, ARGV will look like this:
#     ["node", "/usr/.../lineman/cli.js", "clean", "run"]
#   Now, what we want to do is tell commander to run the `run` action next.
#   We can do that by sending commander.parse(["node", "/usr/...cli.js", "run"])
#   However, we also want to mutate process.argv (yuck) in the event that two
#   chainable commands are repeated. We also want to ensure that any arguments
#   passed to action A are not retained when we re-parse (or else they'll gum
#   up the works).

_ = require("lodash")

module.exports = class RunsNextCommand
  constructor: (commander, currentCommandName) ->
    @commander = commander
    @currentCommandName = currentCommandName
    @nextCommand = @findChainedCommand()
    @overrideLinemanEnv()

  run: =>
    return unless @nextCommand?
    process.argv = @exciseCurrentCommandFromArgv(process.argv)
    @commander.parse(process.argv)

  #private

  findChainedCommand: ->
    _(@commander.commands).find (c) =>
      _(@commander.args).include(c._name)

  exciseCurrentCommandFromArgv: (argv) ->
    currentCommandIndex = process.argv.indexOf(@currentCommandName)
    nextCommandIndex = process.argv.indexOf(@nextCommand._name, currentCommandIndex + 1)
    argv.slice(0, currentCommandIndex).concat(argv.slice(nextCommandIndex))

  overrideLinemanEnv: ->
    return process.env["LINEMAN_ENV"] = "production" if _(process.argv).include("build")
    return process.env["LINEMAN_ENV"] = "test" if _(process.argv).include("spec") || _(process.argv).include("spec-ci")

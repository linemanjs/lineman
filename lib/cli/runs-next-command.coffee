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

  run: =>
    currentCommandIndex = process.argv.indexOf(@currentCommandName)
    if nextCommand = @findChainedCommand(process.argv.slice(currentCommandIndex + 1))
      nextCommandIndex = process.argv.indexOf(nextCommand._name, currentCommandIndex + 1)
      process.argv = process.argv.slice(0,2).concat(process.argv.slice(nextCommandIndex))
      @overrideLinemanEnv()
      @commander.parse(process.argv)

  #private

  findChainedCommand: (args) ->
    _.find @commander.commands, (c) =>
      _.includes(args, c._name)

  overrideLinemanEnv: ->
    return process.env["LINEMAN_ENV"] = "production" if _.includes(process.argv, "build")
    return process.env["LINEMAN_ENV"] = "test" if _.includes(process.argv, "spec") || _.includes(process.argv, "spec-ci")

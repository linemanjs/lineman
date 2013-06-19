_ = require("grunt").util._

module.exports = (commander, gruntCli) ->
  commander.option("--install", "lineman new - Perform an `npm install` when creating a new project, effectively freezing lineman with the project")
  _(gruntCli.optlist).each (option, name) ->
    unless name in ["help", "version"]
      desc = "--#{name}"
      desc = "-#{option.short}, #{desc}" if option.short
      commander.option(desc, "grunt - #{option.info}")


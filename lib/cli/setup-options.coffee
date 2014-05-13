_ = require("lodash")

module.exports = (commander, gruntCli) ->
  commander.option("--install", "lineman new - Perform an `npm install` when creating a new project, effectively freezing lineman with the project")
  commander.option("--skip-examples", "lineman new - Skips the 'hello world' and other example files when creating a new project")
  commander.option("--skip-clean", "lineman build - Builds into the 'dist' directory without emptying it first.")
  commander.option("--process", "lineman config - Process the grunt options, interpolating <%= %> template variables")
  commander.option("--coffee", "lineman new - Create default files in CoffeeScript instead of JavaScript.")
  _(gruntCli.optlist).each (option, name) ->
    unless name in ["help", "version"]
      desc = if option.negate then "--no-#{name}" else "--#{name}"
      desc = "-#{option.short}, #{desc}" if option.short
      commander.option(desc, "grunt - #{option.info}")

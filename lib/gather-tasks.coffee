_ = require('grunt').util._

module.exports = (phase) ->
  config = require("#{process.cwd()}/config/application")
  _([].concat(
    config.prependTasks?[phase]
    (if config.enableSass && phase == "common" then ["sass"] else [])
    config.appTasks?[phase]
    config.appendTasks?[phase]
  )).chain().difference(config.removeTasks?[phase]).compact().value()

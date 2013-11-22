_ = require('grunt').util._

module.exports = (phase) ->
  config = require("#{process.cwd()}/config/application")
  _([].concat(
    config.prependTasks?[phase]
    (if config.enableSass && phase == "common" then ["sass"] else [])
    config.appTasks?[phase]
    config.appendTasks?[phase]
  )).chain().
    tap((tasks) ->
      if config.enableAssetFingerprint && phase == "dist"
        tasks.splice(tasks.indexOf("pages:dist"), 0, "assetFingerprint:dist")
  ).difference(config.removeTasks?[phase]).
  compact().
  value()

_ = require('grunt').util._
buildsAppConfig = require('./../lib/builds-app-config')

module.exports = (phase) ->
  config = buildsAppConfig.forGrunt()
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

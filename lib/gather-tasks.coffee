_ = require("lodash")
buildsAppConfig = require('./../lib/builds-app-config')

module.exports = (phase) ->
  config = buildsAppConfig.forGrunt()
  _([].concat(
    config.prependTasks?[phase]
    (if config.enableSass && phase == "common" then ["sass"] else [])
    config.appTasks?[phase]
    config.appendTasks?[phase]
    (if config.enableAssetFingerprint && phase == "dist" then ["assetFingerprint"] else [])
  )).chain().
    difference(config.removeTasks?[phase]).
    compact().
    value()

buildsAppConfig = require('./builds-app-config')
_ = require('grunt').util._
extend = require('config-extend')

module.exports = (key, config = {}) ->
  original = buildsAppConfig.withPlugins()[key]
  userConfig = if _(config).isFunction() then config(original) else config
  extend(true, {}, original, userConfig)


buildsAppConfig = require('./builds-app-config')
_ = require('lodash')
extend = require('config-extend')

module.exports = (key, config = {}) ->
  original = buildsAppConfig.withPlugins()[key]
  userConfig = if _.isFunction(config) then config(original) else config
  extend(true, {}, original, userConfig)


_ = require('grunt').util._
extend = require('node.extend')

module.exports = (key, config = {}) ->
  original = require(__dirname+"/../config/#{key}")
  override = if _(config).isFunction() then config(original) else config
  extend(true, {}, original, override)

_ = require('grunt').util._

module.exports = class ReadsConfiguration
  read: (propertyPath) ->
    config = require("#{process.cwd()}/config/application")
    value = if propertyPath? then @traverse(propertyPath.split("."), config) else config

  traverse: (paths, value) ->
    if !value? || paths.length == 0
      value
    else if _(paths[0]).include("[")
      [path, prop, index] = paths[0].match(/(.*)\[(\d+)\]/)
      @traverse(_(paths).rest(), value[prop][index])
    else
      @traverse(_(paths).rest(), value[paths[0]])


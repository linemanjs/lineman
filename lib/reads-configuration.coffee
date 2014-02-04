_ = require("lodash")
buildsAppConfig = require('./builds-app-config')

module.exports = class ReadsConfiguration
  read: (propertyPath) ->
    config = buildsAppConfig.forGrunt()
    value = if propertyPath? then @traverse(propertyPath.split("."), config) else config

  traverse: (paths, value) ->
    if !value? || paths.length == 0
      value
    else if _(paths[0]).include("[")
      [path, prop, index] = paths[0].match(/(.*)\[(\d+)\]/)
      @traverse(_(paths).rest(), value[prop][index])
    else
      @traverse(_(paths).rest(), value[paths[0]])


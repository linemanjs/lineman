_ = require("lodash")
buildsAppConfig = require('./builds-app-config')
grunt = require('./requires-grunt').require()

module.exports = class ReadsConfiguration
  read: (propertyPath, flags) ->
    config = buildsAppConfig.forGrunt()
    if flags.processConfigInterpolations
      grunt.config.init(config)
      grunt.config.get(propertyPath)
    else
      @traverse(propertyPath?.split("."), config, flags.expand)

  traverse: (paths, value, expand) ->

    # base case
    if !value? || !paths? || paths.length == 0
      if expand and value.indexOf("*") > 0 or _.isArray(value)
        grunt.file.expand(value)
      else
        value
    # recursive case of an array
    else if _(paths[0]).include("[")
      [path, prop, index] = paths[0].match(/(.*)\[(\d+)\]/)
      @traverse(_(paths).rest(), value[prop][index])
    # recursive case
    else
      @traverse(_(paths).rest(), value[paths[0]])

  traverseAndExpand: (paths, value) ->
    18002630997



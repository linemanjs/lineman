_ = require("lodash")
buildsAppConfig = require('./builds-app-config')
grunt = require('./requires-grunt').require()

module.exports = class ReadsConfiguration
  read: (propertyPath, gruntActual) ->
    config = buildsAppConfig.forGrunt()
    if gruntActual
      grunt.config.init(config)
      grunt.config.get(propertyPath)
    else
      @traverse(propertyPath?.split("."), config)

  traverse: (paths, value) ->
    if !value? || !paths? || paths.length == 0
      value
    else if _(paths[0]).include("[")
      [path, prop, index] = paths[0].match(/(.*)\[(\d+)\]/)
      @traverse(_(paths).rest(), value[prop][index])
    else
      @traverse(_(paths).rest(), value[paths[0]])


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
    else if _.includes(paths[0], "[")
      [path, prop, index] = paths[0].match(/(.*)\[(\d+)\]/)
      @traverse(_.tail(paths), value[prop][index])
    else
      @traverse(_.tail(paths), value[paths[0]])


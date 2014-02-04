path = require('path')
resolvesQuietly = require('./resolves-quietly')

module.exports =
  require: ->
    require(@whereIsGrunt())

  whereIsGrunt: ->
    resolvesQuietly.resolve("grunt", basedir: path.join(__dirname, "..")) ||
    resolvesQuietly.resolve("grunt")


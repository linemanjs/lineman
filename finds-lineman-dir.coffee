resolvesQuietly = require('./lib/resolves-quietly')

module.exports =
  find: ->
    resolvesQuietly.resolve("lineman", {basedir: process.cwd()}) || __dirname


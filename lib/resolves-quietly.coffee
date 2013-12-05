resolve = require('resolve')
path = require('path')

module.exports =
  resolve: (requirable, opts) ->
    try
      path.dirname(resolve.sync(requirable, opts))
    catch e
      undefined

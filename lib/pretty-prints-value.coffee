_ = require("lodash")

module.exports =
  prettyPrint: (value) ->
    return value unless _(value).isObject()
    try
      JSON.stringify(value, null, 2)
    catch e
      value

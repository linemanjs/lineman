_ = require("lodash")

replacer = (key, value) ->
  if _.isFunction(value) then "[Function]" else value

module.exports =
  prettyPrint: (value) ->
    return value if _.isString(value)
    try
      JSON.stringify(value, replacer, indentation = 2)
    catch e
      value

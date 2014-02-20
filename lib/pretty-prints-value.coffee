_ = require("lodash")

replacer = (key, value) ->
  if _(value).isFunction() then "[Function]" else value

module.exports =
  prettyPrint: (value) ->
    return value unless _(value).isObject()
    try
      JSON.stringify(value, replacer, indentation = 2)
    catch e
      value

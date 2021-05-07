td = require('testdouble')

global.requireSubject = (path, deps) ->
  upDirs = "../../../"
  if deps
    Object.keys(deps).forEach (name) ->
      td.replace(upDirs + name, deps[name])

  require(upDirs + path)

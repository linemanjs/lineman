SandboxedModule = require('sandboxed-module')

global.requireSubject = (path, deps) ->
  SandboxedModule.require "./../../../#{path}",
    requires: deps

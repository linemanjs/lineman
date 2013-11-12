SandboxedModule = require('sandboxed-module')
_ = require('underscore')

describe 'gatherTasks', ->
  Given -> @config = appTasks: {}
  Given -> @requires = _({}).tap (requires) =>
    requires["#{process.cwd()}/config/application"] = @config
  Given -> @subject = SandboxedModule.require '../../../../lib/gather-tasks',
    requires: @requires

  context "default -- only config.appTasks", ->
    Given -> @config.appTasks['foo'] = ['a','b']
    When -> @result = @subject('foo')
    Then -> expect(@result).toEqual(['a','b'])

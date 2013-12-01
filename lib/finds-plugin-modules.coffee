_ = require('grunt').util._

module.exports =
  find: ->
    packageJson = require("#{process.cwd()}/package.json")
    moduleNames = _({}).
      chain().
      extend(packageJson.optionalDependencies, packageJson.devDependencies, packageJson.dependencies).
      keys().
      select (dep) ->
        _.str.startsWith(dep, "lineman-")
      .value()

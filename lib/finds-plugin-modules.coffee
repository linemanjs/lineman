_ = require("lodash")
_str = require("underscore.string")
resolvesQuietly = require('./../lib/resolves-quietly')
semver = require('semver')
fs = require('fs')

module.exports =
  find: ->
    prune(plugins())

plugins = (dir = process.cwd(), depth = 0, knownPlugins = []) ->
  return [] unless fs.existsSync(dir)
  moduleNames = _(packageDependencies(dir))
    .chain()
    .keys()
    .select(isLinemanPlugin)
    .map(pluginObjectBuilder(dir, depth))
    .reduce(descendantPluginCollector(depth, knownPlugins), [])
    .value()

packageDependencies = (dir) ->
  packageJson = require("#{dir}/package")
  _({}).extend(packageJson.optionalDependencies, packageJson.devDependencies, packageJson.dependencies)

isLinemanPlugin = (name) -> _str.startsWith(name, "lineman-")

pluginObjectBuilder = (dir, depth) ->
  (name) ->
    dir = resolvesQuietly.resolve(name, basedir: dir)
    version = require("#{dir}/package").version
    {name, version, dir, depth}

descendantPluginCollector = (depth, knownPlugins) ->
  (deps, dep) ->
    allDeps = knownPlugins.concat(deps)
    known = _(allDeps).any(knownPluginFinder(dep, depth))
    descendants = plugins(dep.dir, depth + 1, allDeps) unless known
    tidyUnion(deps, descendants, dep)

knownPluginFinder = (dep, depth) ->
  (plugin) -> plugin.name == dep.name && plugin.depth <= depth

prune = (plugins) ->
  _(plugins)
    .chain()
    .groupBy("name")
    .map(shallowestDepthAndHighestVersion)
    .value()

shallowestDepthAndHighestVersion = (plugins) ->
  _(plugins).chain()
    .selectMin("depth")
    .reduce (highest, plugin) ->
      if semver.gt(plugin.version, highest.version) then plugin else highest
    .value()

tidyUnion = (array, moreArrays...) ->
  _(array).chain().union(moreArrays...).compact().value()

_.mixin
  selectMin: (items, property) ->
    min = _(items).chain().pluck(property).min((val) -> val).value()
    _(items).select (item) -> item[property] == min

_ = require("lodash")
_str = require("underscore.string")
resolvesQuietly = require('./../lib/resolves-quietly')
semver = require('semver')
fs = require('fs')
path = require('path')
grunt = require('./requires-grunt').require()

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
  packageJson = require(path.join(dir, "package"))
  _({}).extend(packageJson.optionalDependencies, packageJson.devDependencies, packageJson.dependencies)

isLinemanPlugin = (name) -> _str.startsWith(name, "lineman-")

pluginObjectBuilder = (basedir, depth) ->
  (name) ->
    if dir = resolvesQuietly.resolve(name, basedir: basedir)
      version = require(path.join(dir, "package")).version
      {name, version, dir, depth}
    else
      grunt.warn """
                 Could not find plugin "#{name}", even though it was listed in your "package.json" file.

                 You probably need to run `npm install #{name}`

                 (Performed search from "#{basedir}")
                 """

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

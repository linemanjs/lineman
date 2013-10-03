semver = require('semver')

module.exports = ->
  return unless specifiedVersion = specifiedLinemanVersion()
  return unless semver.validRange(specifiedVersion)

  actualVersion = actualLinemanVersion()
  unless semver.satisfies(actualVersion, specifiedVersion)
    console.error """
                  Uh oh, your package.json specifies lineman version '#{specifiedVersion}', but Lineman is currently '#{actualVersion}'.

                  Possible solutions:
                    * Try running `npm install` to install the specified lineman version locally to `node_modules/lineman`
                    * Update (or, perhaps, remove!) the version of lineman you've specified in your `package.json` and see if it works.
                  """
    process.exit(1)

specifiedLinemanVersion = ->
  packageJson = loadPackageJson()
  packageJson?.dependencies?.lineman || packageJson?.devDependencies?.lineman

actualLinemanVersion = ->
  if process.env["LINEMAN_MAIN"] == "lineman"
    require("#{process.cwd()}/node_modules/lineman/package").version
  else
    require(process.env["LINEMAN_MAIN"]).version

loadPackageJson = ->
  try
    require("#{process.cwd()}/package.json")
  catch e
    undefined

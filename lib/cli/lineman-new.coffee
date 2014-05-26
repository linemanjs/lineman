files = require("./../file-utils")
fs = require('fs')
_ = require("lodash")

module.exports = (projectName, shouldNpmInstall, shouldSkipExamples, shouldCoffeeify) ->
  ensureNotEmpty(projectName)
  dest = "#{process.cwd()}/#{projectName}"
  ensureNew(dest)
  printHello(dest)
  copyArchetype(dest, projectName)
  convertJs2Coffee(dest) if shouldCoffeeify
  deleteExampleFiles(dest) if shouldSkipExamples
  if shouldNpmInstall
    npmInstallTo(dest, projectName)
  else
    printWelcome(projectName)

ensureNotEmpty = (projectName) ->
  fail("Usage: `lineman new <name>`") if _(projectName).isEmpty() || !_(projectName).isString()

ensureNew = (dest) ->
  fail("Uh oh, it looks like `#{dest}` already exists! Exiting.") if fs.existsSync(dest)

printHello = (dest) ->
  console.log """
                  _      _
                 | |    (_)
                 | |     _ _ __   ___ _ __ ___   __ _ _ __
                 | |    | | '_ \\ / _ \\ '_ ` _ \\ / _` | '_ \\
                 | |____| | | | |  __/ | | | | | (_| | | | |
                 |______|_|_| |_|\\___|_| |_| |_|\\__,_|_| |_|

              - Assembling your new project directory in '#{dest}'
              """

copyArchetype = (dest, projectName) ->
  files.copyDir("#{__dirname}/../../archetype/", dest)
  files.overwritePackageJson("#{dest}/package.json", projectName)
  files.copy("#{dest}/.npmignore", "#{dest}/.gitignore")

convertJs2Coffee = (dest) ->
  require("./../coffeeifies-archetype").coffeeify(dest)

deleteExampleFiles = (dest) ->
  _([
    "app/css/style.css",
    "app/js/hello.coffee",
    "app/templates/hello.us",
    "app/static/favicon.ico",
    "spec/hello-spec.coffee",
    "vendor/js/underscore.js"
  ]).each (path) ->
    fs.unlink("#{dest}/#{path}")

npmInstallTo = (dest, projectName) ->
  console.log(" - Performing `npm install`. Lineman will install into (and run out of) this project's `node_modules/lineman` directory.")
  require("./../npm-utils").installFrom dest, (error) ->
    console.warn("WARNING: `npm install` failed! You might try again later inside the project directory") if error
    printWelcome(projectName)

printWelcome = (projectName) ->
  console.info """
               - Created a new project in "#{projectName}/" with Lineman. Yay!

               Getting started:
                 1. `cd #{projectName}` into your new project directory'
                 2. Start working on your project!
                   * `lineman run` starts a web server at http://localhost:8000
                   * `lineman build` bundles a distribution in the "dist" directory
                   * `lineman clean` empties the "dist" and "generated" directories
                   * `lineman spec` runs specs from the "specs" directory using testem
                   * `lineman config <property path>` reads a configuration value
                   * `lineman fetch <library name>` downloads a 3rd-party library

               For more info, check out http://github.com/linemanjs/lineman
               """

fail = (message) ->
  console.error(message)
  process.exit(1)

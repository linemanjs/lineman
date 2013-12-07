rimraf = require('rimraf')
fs = require('fs')
tempDir = process.env.SPEC_TEMP_DIR = "#{process.cwd()}/tmp"

module.exports = self =
  create: ->
    fs.mkdirSync(tempDir) unless fs.existsSync(tempDir)
  delete: ->
    if fs.existsSync(tempDir)
      rimraf.sync(process.env.SPEC_TEMP_DIR)

beforeAll ->
  self.delete()
  self.create()



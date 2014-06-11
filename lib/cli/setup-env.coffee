fs = require('fs')

module.exports = ->
  process.env["LINEMAN_MAIN"] = findTheRightLineman()
  process.env["LINEMAN_ENV"] ||= "development"

findTheRightLineman = ->
  return "lineman" if fs.existsSync("#{process.cwd()}/node_modules/lineman")
  "#{__dirname}/../../lineman.js"

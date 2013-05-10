fs = require('fs')

module.exports = ->
  process.env["LINEMAN_MAIN"] = findTheRightLineman()

findTheRightLineman = ->
  return "lineman" if fs.existsSync("#{process.cwd()}/node_modules/lineman")
  "#{__dirname}/../../lineman.js"

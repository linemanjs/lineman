wd = require 'wd'

beforeAll (done) ->
  global.browser = wd.remote()
  browser.init
    browserName: process.env.USE_BROWSER || 'phantomjs'
  , done

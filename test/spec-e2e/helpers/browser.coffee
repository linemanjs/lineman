wd = require 'wd'

beforeEach (done) ->
  global.browser = wd.remote()
  browser.init
    browserName: process.env.USE_BROWSER || 'phantomjs'
  , done


afterEach ->
  browser.quit()

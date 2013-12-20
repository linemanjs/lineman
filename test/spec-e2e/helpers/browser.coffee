webdriverSync = require('webdriver-sync')

global.browser = if process.env.HEADLESS
  new webdriverSync.PhantomJSDriver()
else
  new webdriverSync.ChromeDriver()

browser.eval = (code) ->
  browser.executeScript("return #{code}")

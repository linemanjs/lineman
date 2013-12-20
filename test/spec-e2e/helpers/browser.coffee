wd = require('webdriver-sync')

beforeAll ->
  global.browser = if process.env.HEADLESS then new wd.PhantomJSDriver() else new wd.ChromeDriver()
  browser.eval = (code) -> browser.executeScript("return #{code}")

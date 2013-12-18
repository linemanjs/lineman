wd = require('webdriver-sync')

beforeAll ->
  global.browser = new wd.ChromeDriver()
  browser.eval = (code) -> browser.executeScript("return #{code}")

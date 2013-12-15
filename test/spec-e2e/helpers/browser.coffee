wd = require 'webdriver-sync'

beforeEach ->
  global.browser = new wd.ChromeDriver()

afterEach ->
  browser.quit()

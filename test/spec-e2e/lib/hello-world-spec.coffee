describe "the hello world project", ->
  beforeAll (done) -> lineman.new("hello-world", done)

  sharedExamplesFor "a hello world", ->
    When -> @el = browser.findElementByCssSelector('.hello')
    Then -> "Hello, World!" == @el.getText()
    And -> @el.getCssValue('backgroundColor') == "rgb(239, 239, 239)"

  describe "lineman build", ->
    Given (done) -> lineman.build(done)
    When -> browser.get("file://#{lineman.projectPath()}/dist/index.html")
    itBehavesLike "a hello world"

  describe "lineman run", ->
    beforeAll (done) -> lineman.currentRun = lineman.run(done)
    When -> browser.get("http://localhost:8000")

    itBehavesLike "a hello world"

    describe "adding a CoffeeScript file", ->
      Given -> linemanProject.addFile("app/js/foo.coffee", "window.pants = -> 'yay!'")
      Given (done) -> setTimeout(done, 1000)
      Then -> browser.eval("pants()") == "yay!"

      describe "then editing the file", ->
        Given -> linemanProject.addFile("app/js/foo.coffee", "window.hats = -> 'yay!'")
        Given (done) -> setTimeout(done, 1000)
        Then -> browser.eval("hats()") == "yay!"
        And -> browser.eval("pants") == undefined

      describe "then removing the file", ->
        Given -> linemanProject.removeFile("app/js/foo.coffee")
        Given (done) -> setTimeout(done, 1000)
        Then -> browser.eval("pants") == undefined

    afterAll -> lineman.currentRun.kill('SIGKILL')


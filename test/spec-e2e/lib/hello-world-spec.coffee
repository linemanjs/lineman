describe "the hello world project", ->
  Given (done) -> lineman.new("hello-world", done)

  afterEach ->
    lineman.kill()

  sharedExamplesFor "a hello world", ->
    When -> @el = browser.findElementByCssSelector('.hello')
    Then -> "Hello, World!" == @el.getText()
    And -> @el.getCssValue('backgroundColor') == "rgb(239, 239, 239)"

  describe "lineman build", ->
    Given (done) -> lineman.build(done)
    Given -> browser.get("file://#{lineman.projectPath()}/dist/index.html")
    itBehavesLike "a hello world"

  describe "lineman run", ->
    Given (done) -> lineman.run(done)
    Given -> browser.get(lineman.baseUrl())

    describe "hello world", ->
      itBehavesLike "a hello world"

    describe "adding a CoffeeScript file", ->
      Given -> linemanProject.addFile("app/js/foo.coffee", "window.pants = -> 'yay!'")

      WaitForJs 5, -> window.pants != undefined

      describe "without any further tomfoolery", ->
        When -> browser.navigate().refresh()
        Then -> browser.eval("pants()") == "yay!"

      describe "then editing the file", ->
        Given -> linemanProject.addFile("app/js/foo.coffee", "window.hats = -> 'yay!'")
        WaitForJs 5, -> window.hats != undefined
        When -> browser.navigate().refresh()
        Then -> browser.eval("hats()") == "yay!"
        And -> browser.eval("window.pants === undefined")

      describe "then removing the file", ->
        Given -> linemanProject.removeFile("app/js/foo.coffee")
        WaitForJs 5, -> window.pants == undefined
        When -> browser.navigate().refresh()
        Then -> browser.eval("window.pants === undefined")


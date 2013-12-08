describe "the hello world project", ->
  beforeAll (done) -> lineman.new("hello-world", done)

  sharedExamplesFor "a hello world", ->
    When (done) -> browser.elementByCss ".hello", (err, el) => @el = el; done()

    Then (done) ->  browser.text @el, (err, text) ->
      expect(text).toEqual("Hello, World!")
      done()
    And (done) -> browser.getComputedCss @el, "backgroundColor", (err, css) ->
      expect(css).toEqual("rgb(239, 239, 239)")
      done()

  describe "lineman build", ->
    Given (done) -> lineman.build(done)
    When (done) -> browser.get("file://#{lineman.projectPath()}/dist/index.html", done)
    itBehavesLike "a hello world"

  describe "lineman run", ->
    beforeAll (done) -> lineman.currentRun = lineman.run(done)
    When (done) -> browser.get("http://localhost:8000", done)

    itBehavesLike "a hello world"

    describe "adding a CoffeeScript file", ->
      Given -> linemanProject.addFile("app/js/foo.coffee", "window.pants = -> 'yay!'")
      Given (done) -> setTimeout(done, 1000)
      Then (done) -> browser.eval "pants()", (err, val) ->
        expect(val).toEqual("yay!")
        done()

      describe "then editing the file", ->
        Given -> linemanProject.addFile("app/js/foo.coffee", "window.hats = -> 'yay!'")
        Given (done) -> setTimeout(done, 1000)
        Then (done) -> browser.eval "hats()", (err, val) ->
          expect(val).toEqual("yay!")
          done()
        And (done) -> browser.eval "pants", (err, val) ->
          expect(val).not.toBeDefined()
          done()

      describe "then removing the file", ->
        Given -> linemanProject.removeFile("app/js/foo.coffee")
        Given (done) -> setTimeout(done, 1000)
        Then (done) -> browser.eval "pants", (err, val) ->
          expect(val).not.toBeDefined()
          done()

    afterAll -> lineman.currentRun.kill('SIGKILL')


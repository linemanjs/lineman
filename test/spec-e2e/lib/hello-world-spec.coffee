describe.only "the hello world project", ->
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
    Given (done) -> browser.get("file://#{lineman.projectPath()}/dist/index.html", done)
    itBehavesLike "a hello world"

  describe "lineman run", ->
    Given (done) -> @child = lineman.run(done)
    Given (done) -> browser.get("http://localhost:8000", done)
    itBehavesLike "a hello world"
    afterEach -> @child.kill('SIGKILL')

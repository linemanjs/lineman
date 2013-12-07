describe.only "the hello world project", ->
  Given (done) -> lineman.new("foo", done)

  describe "lineman build", ->
    Given (done) -> lineman.build(done)
    Given (done) -> browser.get("file://#{lineman.projectPath()}/dist/index.html", done)
    When (done) -> browser.elementByCss ".hello", (err, el) => @el = el; done()
    Then (done) ->  browser.text @el, (err, text) ->
      expect(text).toEqual("Hello, World!")
      done()
    And (done) -> browser.getComputedCss @el, "backgroundColor", (err, css) ->
      expect(css).toEqual("rgb(239, 239, 239)")
      done()

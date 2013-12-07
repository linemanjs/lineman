describe "watching files", ->
  Given (done) -> browser.get "http://admc.io/wd/test-pages/guinea-pig.html", done
  When (done) ->  browser.title (err, title) => @result = title; done()
  Then -> @result == "WD Tests"



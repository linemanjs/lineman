global.Wait = (upToSeconds, untilThisReturnsTrue, increment = 1500, customError) ->
  waitedSoFar = 0

  Given (done) ->
    tryAgain = ->
      if waitedSoFar > upToSeconds * 1000
        console.error """
                      Timed out while waiting #{waitedSoFar / 1000.0} seconds for:

                      #{customError || untilThisReturnsTrue.toString()}

                      To return true. It never happened.
                      """
        done(false)
      else
        waitedSoFar += increment
        setTimeout(testPredicate, increment)

    testPredicate = ->
      if untilThisReturnsTrue() == true then done() else tryAgain()

    testPredicate()


global.WaitForJs = (upToSeconds, untilThisReturnsTrue, increment) ->
  browserPredicate = ->
    browser.navigate().refresh()
    browser.eval("(#{untilThisReturnsTrue.toString()})();")
  Wait(upToSeconds, browserPredicate, increment, untilThisReturnsTrue.toString())

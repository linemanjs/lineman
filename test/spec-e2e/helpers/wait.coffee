
global.Wait = (upToSeconds, untilThisReturnsTrue, increment = 2000) ->
  totalWait = upToSeconds * 1000
  waitedSoFar = 0
  everTurnedTrue = false

  Given (done) ->
    tryAgain = ->
      if waitedSoFar > totalWait
        throw new Error """
                        Timed out while waiting #{waitedSoFar / 1000.0} seconds for:

                        #{untilThisReturnsTrue.toString()}

                        To return true. It never happened.
                        """
      else
        waitedSoFar += increment
        setTimeout ->
          console.log("Running after #{waitedSoFar}ms for #{untilThisReturnsTrue.toString()}")
          if untilThisReturnsTrue() == true
            done()
          else
            tryAgain()
        , increment
    if untilThisReturnsTrue()
      done()
    else
      tryAgain()

global.WaitForJs = (upToSeconds, untilThisReturnsTrue, increment = 2000) ->
  Wait upToSeconds, ->
    browser.navigate().refresh()
    browser.eval("(#{untilThisReturnsTrue.toString()})();")
  , increment

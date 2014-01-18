global.Wait = (seconds) ->
  Given (done) -> setTimeout(done, seconds * 1000)

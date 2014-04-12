module.exports = class AccumulatesStreams
  constructor: (@stream, @writeToStdout = true, @event = "data") ->
    @value = ""

  accumulate: ->
    @stream.on @event, (stuff) =>
      chunk = String(stuff)
      process.stdout.write(chunk) if @writeToStdout
      @value += chunk
    this

  getValue: -> @value

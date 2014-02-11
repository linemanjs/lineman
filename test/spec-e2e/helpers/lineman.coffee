grunt = require('grunt')
spawn = require("child_process").spawn

currentLinemanPath = null
currentLinemanRuns = []
linemanBinPath = "#{process.cwd()}/../cli.js"
currentPort = 8001

global.lineman = module.exports =
  new: (name, callback, done) ->
    currentLinemanPath = process.env.SPEC_TEMP_DIR
    name += "-#{new Date().getTime()}"
    exec("new", "--stack", name, standardResponder(callback, done))
    currentLinemanPath += "/#{name}"

  build: (callback, done) ->
    exec("build", "--stack", standardResponder(callback, done))

  run: (done) ->
    process.env.WEB_PORT = ++currentPort
    _(exec("run", "--stack", ->)).tap (child) ->
      setTimeout(done, 4000)

  projectPath: -> currentLinemanPath
  baseUrl: -> "http://localhost:#{currentPort}"

  kill: ->
    _(currentLinemanRuns).each (process) ->
      process.kill('SIGKILL')
    currentLinemanRuns = []

exec = (args..., callback) ->
  chdir currentLinemanPath, ->
    child = spawn(linemanBinPath, args)
    result = ""
    child.stdout.on "data", (data) ->
      result += data.toString()

    child.on "close", (code) ->
      if Number(code) == 0
        callback?(result)
      else
        throw new Error """
                        Failed when running `lineman #{args.join(' ')}`.

                        Message:
                        #{result}
                        """
    currentLinemanRuns.push(child)
    child

chdir = (newPath, doStuff) ->
  oldPath = process.cwd()
  process.chdir(newPath)
  val = doStuff()
  process.cwd(oldPath)
  return val

standardResponder = (callback, done) ->
  (result) ->
    if done?
      callback(result)
      done()
    else
      callback()

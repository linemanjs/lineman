grunt = require('grunt')
spawn = require("child_process").spawn

currentLinemanPath = null
linemanBinPath = "#{process.cwd()}/../cli.js"

global.lineman =
  projectPath: -> currentLinemanPath
  new: (name, callback, done) ->
    currentLinemanPath = process.env.SPEC_TEMP_DIR
    exec("new", name, standardResponder(callback, done))
    currentLinemanPath += "/#{name}"

  build: (callback, done) ->
    exec("build", standardResponder(callback, done))

exec = (args..., callback) ->
  chdir currentLinemanPath, ->
    child = spawn(linemanBinPath, args)
    result = ""
    child.stdout.on "data", (data) ->
      result += data.toString()

    child.on "close", (code) ->
      if code == 0
        callback(result)
      else
        throw new Error """
                        Failed when running `lineman #{args.join(' ')}`.

                        Message:
                        #{result}
                        """
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

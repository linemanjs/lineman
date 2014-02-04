_ = require("lodash")
exec = require("child_process").exec

module.exports = ((_, exec) ->
  _({}).tap (exports) ->
    exports.installFrom = (path, callback) ->
      process.chdir(path)
      console.info " - Running `#{command}` to install dependencies for your new project..."
      exec command, (error, stdout, stderr) ->
        if error
          console.error("Uh oh! An error occurred while running `#{command}`.")
          console.info(stdout)
          console.error(stderr)
        callback(error)

    command = "npm install"

)(_, exec)

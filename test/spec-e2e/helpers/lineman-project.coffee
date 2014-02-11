grunt = require('grunt')

global.linemanProject = module.exports =
  addFile: (path, contents, done) ->
    grunt.file.write(pathFor(path), contents)
    setTimeout ->
      done()
    , 1000 if done?

  removeFile: (path, done) ->
    grunt.file.delete(pathFor(path))
    setTimeout ->
      done()
    , 1000 if done?

pathFor = (path) ->
  "#{lineman.projectPath()}/#{path}"

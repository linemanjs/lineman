grunt = require('grunt')

global.linemanProject = module.exports =
  addFile: (path, contents) ->
    grunt.file.write(pathFor(path), contents)

  removeFile: (path) ->
    grunt.file.delete(pathFor(path))

pathFor = (path) ->
  "#{lineman.projectPath()}/#{path}"

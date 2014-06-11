linemanFetch = require('./../lib/cli/lineman-fetch')

module.exports = (grunt) ->
  grunt.registerTask "fetch", "invoke `lineman fetch` as part of your build", (recipeNames...) ->
    linemanFetch(recipeNames, @async())

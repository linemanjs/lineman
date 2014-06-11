grunt = require('./../requires-grunt').require()
fetcher = require('fetcher')

module.exports = (recipes = [], cb) ->
  return displayHelp() if recipes.length == 0
  fetcher recipes, {recipeRepo: "https://github.com/linemanjs/fetcher-recipes.git"}, (er) ->
    grunt.warn(er) if er?
    return cb?(er) if er?
    cb?(null)

displayHelp = ->
  grunt.warn """

            Usage: `lineman fetch <recipe_name>`

            For a list of available recipes, see:
            https://github.com/linemanjs/fetcher-recipes/tree/master/recipes

            """

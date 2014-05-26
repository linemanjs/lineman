grunt = require('./../requires-grunt').require()
fetcher = require('fetcher')

module.exports = (recipes = []) ->
  return displayHelp() if recipes.length == 0
  fetcher recipes, {recipeRepo: "git@github.com:linemanjs/fetcher-recipes.git"}, (er) ->
    grunt.warn(er) if er?

displayHelp = ->
  grunt.warn """

            Usage: `lineman fetch <recipe_name>`

            For a list of available recipes, see:
            https://github.com/linemanjs/fetcher-recipes/tree/master/recipes

            """

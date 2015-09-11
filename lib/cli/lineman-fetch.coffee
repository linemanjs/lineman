grunt = require('./../requires-grunt').require()
fetcher = require('fetcher')

module.exports = (recipes = [], recipeRepo = "https://github.com/linemanjs/fetcher-recipes", cb) ->
  return displayHelp(recipeRepo) if recipes.length == 0
  fetcher recipes, {recipeRepo}, (er) ->
    grunt.warn(er) if er?
    return cb?(er) if er?
    cb?(null)

displayHelp = (recipeRepo) ->
  grunt.warn """

            Usage: `lineman fetch <recipe_name>`

            For a list of available recipes, see:
            #{recipeRepo}/tree/master/recipes
            """

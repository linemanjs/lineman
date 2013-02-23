#global module:false
module.exports = (grunt) ->
  require('./lineman').config.grunt.run(grunt)
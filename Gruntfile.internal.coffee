#global module:false

# Note: this Gruntfile is only for lineman's internal development
#  and, unlike almost everything else to do with Grunt, is not intended
#  for use by people's Lineman projects.
#
# Running internal grunt commands requires the --gruntfile option
#
#   $ grunt release --gruntfile Gruntfile.internal.coffee --no-write

module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-release')

  grunt.initConfig
    release:
      options:
        commitMessage: '<%= version %>'
        tagMessage: '<%= version %>'
        github:
          repo: 'linemanjs/lineman'
          usernameVar: 'GITHUB_USERNAME'
          passwordVar: 'GITHUB_PASSWORD'

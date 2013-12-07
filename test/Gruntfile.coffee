#global module:false
module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-jasmine-bundle')

  grunt.initConfig
    spec:
      options:
        minijasminenode:
          showColors: true

      unit:
        options:
          helpers: "spec-unit/helpers/**/*.{js,coffee}"
          specs: "spec-unit/**/*.{js,coffee}"

      e2e:
        options:
          helpers: "spec-e2e/helpers/**/*.{js,coffee}"
          specs: ["spec-e2e/**/*.{js,coffee}", "!spec-e2e/tmp/**"]

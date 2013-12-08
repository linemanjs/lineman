#global module:false

module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-jasmine-bundle')

  grunt.initConfig
    spec:
      unit:
        options:
          helpers: "spec-unit/helpers/**/*.{js,coffee}"
          specs: "spec-unit/**/*.{js,coffee}"
          minijasminenode:
            showColors: true

      e2e:
        options:
          helpers: "spec-e2e/helpers/**/*.{js,coffee}"
          specs: ["spec-e2e/**/*.{js,coffee}", "!spec-e2e/tmp/**"]
          minijasminenode:
            showColors: true
            defaultTimeoutInterval: 10000
            onComplete: ->
              require("./spec-e2e/helpers/tmp").delete()
              browser?.quit()

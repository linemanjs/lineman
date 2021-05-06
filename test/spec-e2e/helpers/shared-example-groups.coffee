root = global
_ = require('underscore')
grunt = require('grunt')
sharedExamples = {}

root.sharedExamplesFor = (name, func) ->
  throw "Shared examples named #{name} already exists!" if sharedExamples[name]?
  sharedExamples[name] = func

root.itBehavesLike = (name) ->
  examples = sharedExamples[name]
  throw "No shared examples named `#{name}` found!" unless examples?
  describe("Shared examples for #{name}", examples)

_.each grunt.file.expand("#{__dirname}/shared-example-groups/**/*.{js,coffee}"), (f) ->
  require(f).registerExamples()

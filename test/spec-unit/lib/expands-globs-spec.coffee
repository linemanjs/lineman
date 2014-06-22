describe "expandsGlobs", ->
  Given ->
    @subject = requireSubject("lib/expands-globs")
    @expander = spyOn(@subject, 'expand')
    @processedConfig =
      files:
        coffee:
          app: [
            "app/js/bootstrap.coffee"
            "app/**/*.coffee"
          ]
          spec: "app/**/*.coffee"

  describe ".expand", ->
    context "an array", ->
      When  -> @subject.expandGlobs(@processedConfig.files.coffee.app)
      Then  -> @expander.calls.length == 1

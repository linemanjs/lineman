describe 'gatherTasks', ->
  Given -> @buildsAppConfig =
    forGrunt: jasmine.createSpy('forGrunt').andCallFake => @config
  Given -> @subject = requireSubject "lib/gather-tasks",
    './../lib/builds-app-config': @buildsAppConfig

  describe "general phase behavior", ->
    When -> @result = @subject('foo')

    context "uncustomized", ->
      Given -> @config =
        appTasks:
          foo: ["a","b"]
      Then -> expect(@result).toEqual(["a","b"])

    context "prepended task", ->
      Given -> @config =
        prependTasks:
          foo: ["b"]
        appTasks:
          foo: ["a"]
      Then -> expect(@result).toEqual(["b","a"])

    context "appended task", ->
      Given -> @config =
        appendTasks:
          foo: ["c"]
        appTasks:
          foo: ["b"]
      Then -> expect(@result).toEqual(["b","c"])

    context "removed task", ->
      Given -> @config =
        prependTasks:
          foo: ["a"]
        appTasks:
          foo: ["b"]
        appendTasks:
          foo: ["c","d"]
        removeTasks:
          foo: ["a", "b", "c"]
      Then -> expect(@result).toEqual(["d"])

    context "with some nulls/undefineds", ->
      Given -> @config =
        appTasks:
          foo: [null, undefined, "a", null, "b"]
      Then -> expect(@result).toEqual(["a", "b"])

  describe "sass flag", ->
    Given -> @config =
      enableSass: true
      prependTasks:
        foo: ["a"]
        common: ["a2"]
      appTasks:
        foo: ["b"]
        common: ["b2"]

    context "common phase", ->
      When -> @result = @subject("common")
      Then -> expect(@result).toEqual(["a2", "sass", "b2"])

    context "non-common phase", ->
      When -> @result = @subject("foo")
      Then -> expect(@result).toEqual(["a", "b"])

  describe "assetFingerprint flag", ->
    Given -> @config =
      enableAssetFingerprint: true
      appTasks: {}

    When -> @result = @subject(@phase)

    context "dist", ->
      Given -> @phase = "dist"
      context "normal", ->
        Given -> @config.appTasks[@phase] = ["foo", "pages:dist"]
        Then -> expect(@result).toEqual(["foo", "assetFingerprint:dist", "pages:dist"])

      context "with pages removed", ->
        Given -> @config.appTasks[@phase] = ["foo"]
        Then -> expect(@result).toEqual(["foo", "assetFingerprint:dist"])

    context "non-dist", ->
      Given -> @phase = "bar"
      Given -> @config.appTasks[@phase] = ["foo"]
      Then -> expect(@result).toEqual(["foo"])





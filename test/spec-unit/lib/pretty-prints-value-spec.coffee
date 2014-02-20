describe "prettyPrintsValue", ->
  Given -> @subject = requireSubject("lib/pretty-prints-value")

  describe ".prettyPrint", ->
    Then -> @subject.prettyPrint("blah") == "blah"
    Then -> @subject.prettyPrint(true) == true
    Then -> @subject.prettyPrint(false) == false
    Then -> @subject.prettyPrint(39) == 39
    Then -> @subject.prettyPrint(undefined) == undefined
    Then -> @subject.prettyPrint({}) == "{}"
    Then -> expect(@subject.prettyPrint({foo: 'bar', baz: 'biz', nest: {wow: 18}})).toEqual """
      {
        "foo": "bar",
        "baz": "biz",
        "nest": {
          "wow": 18
        }
      }
      """

    describe "doesn't omit function properties", ->
      Then -> expect(@subject.prettyPrint({f: ->})).toEqual """
      {
        "f": "[Function]"
      }
      """

    describe "catch on cyclical exceptions and revert to default object", ->
      Given -> @foo = a: 'b'
      Given -> @bar = foo: @foo
      Given -> @foo.bar = @bar
      When -> @result = @subject.prettyPrint(@foo)
      Then -> @result == @foo

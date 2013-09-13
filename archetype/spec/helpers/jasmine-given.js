/* jasmine-given - 2.2.0
 * Adds a Given-When-Then DSL to jasmine as an alternative style for specs
 * https://github.com/searls/jasmine-given
 */
(function() {
  (function(jasmine) {
    var declareJasineSpec, getBlock, invariantList, mostRecentExpectations, mostRecentlyUsed, o, root, stringifyExpectation, whenList;
    mostRecentlyUsed = null;
    stringifyExpectation = function(expectation) {
      var matches;
      matches = expectation.toString().replace(/\n/g, '').match(/function\s?\(\)\s?{\s*(return\s+)?(.*?)(;)?\s*}/i);
      if (matches && matches.length >= 3) {
        return matches[2];
      } else {
        return "";
      }
    };
    beforeEach(function() {
      return this.addMatchers({
        toHaveReturnedFalseFromThen: function(context, n) {
          var e, exception, result;
          result = false;
          exception = void 0;
          try {
            result = this.actual.call(context);
          } catch (_error) {
            e = _error;
            exception = e;
          }
          this.message = function() {
            var msg;
            msg = "Then clause " + (n > 1 ? " #" + n : "") + " `" + (stringifyExpectation(this.actual)) + "` failed by ";
            if (exception) {
              msg += "throwing: " + exception.toString();
            } else {
              msg += "returning false";
            }
            return msg;
          };
          return result === false;
        }
      });
    });
    root = this;
    root.Given = function() {
      mostRecentlyUsed = root.Given;
      return beforeEach(getBlock(arguments));
    };
    whenList = [];
    root.When = function() {
      var b;
      mostRecentlyUsed = root.When;
      b = getBlock(arguments);
      beforeEach(function() {
        return whenList.push(b);
      });
      return afterEach(function() {
        return whenList.pop();
      });
    };
    invariantList = [];
    root.Invariant = function(invariantBehavior) {
      mostRecentlyUsed = root.Invariant;
      beforeEach(function() {
        return invariantList.push(invariantBehavior);
      });
      return afterEach(function() {
        return invariantList.pop();
      });
    };
    getBlock = function(thing) {
      var assignResultTo, setupFunction;
      setupFunction = o(thing).firstThat(function(arg) {
        return o(arg).isFunction();
      });
      assignResultTo = o(thing).firstThat(function(arg) {
        return o(arg).isString();
      });
      return function() {
        var context, result;
        context = jasmine.getEnv().currentSpec;
        result = setupFunction.call(context);
        if (assignResultTo) {
          if (!context[assignResultTo]) {
            return context[assignResultTo] = result;
          } else {
            throw new Error("Unfortunately, the variable '" + assignResultTo + "' is already assigned to: " + context[assignResultTo]);
          }
        }
      };
    };
    mostRecentExpectations = null;
    declareJasineSpec = function(specArgs, itFunction) {
      var expectationFunction, expectations, label;
      if (itFunction == null) {
        itFunction = it;
      }
      label = o(specArgs).firstThat(function(arg) {
        return o(arg).isString();
      });
      expectationFunction = o(specArgs).firstThat(function(arg) {
        return o(arg).isFunction();
      });
      mostRecentlyUsed = root.subsequentThen;
      mostRecentExpectations = expectations = [expectationFunction];
      itFunction("then " + (label != null ? label : stringifyExpectation(expectations)), function() {
        var block, expectation, i, _i, _j, _len, _len1, _ref, _ref1, _results;
        _ref = whenList != null ? whenList : [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          block = _ref[_i];
          block();
        }
        _ref1 = invariantList.concat(expectations);
        _results = [];
        for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
          expectation = _ref1[i];
          _results.push(expect(expectation).not.toHaveReturnedFalseFromThen(jasmine.getEnv().currentSpec, i + 1));
        }
        return _results;
      });
      return {
        Then: subsequentThen,
        And: subsequentThen
      };
    };
    root.Then = function() {
      return declareJasineSpec(arguments);
    };
    root.Then.only = function() {
      return declareJasineSpec(arguments, it.only);
    };
    root.subsequentThen = function(additionalExpectation) {
      mostRecentExpectations.push(additionalExpectation);
      return this;
    };
    mostRecentlyUsed = root.Given;
    root.And = function() {
      return mostRecentlyUsed.apply(this, jasmine.util.argsToArray(arguments));
    };
    return o = function(thing) {
      return {
        isFunction: function() {
          return Object.prototype.toString.call(thing) === "[object Function]";
        },
        isString: function() {
          return Object.prototype.toString.call(thing) === "[object String]";
        },
        firstThat: function(test) {
          var i;
          i = 0;
          while (i < thing.length) {
            if (test(thing[i]) === true) {
              return thing[i];
            }
            i++;
          }
          return void 0;
        }
      };
    };
  })(jasmine);

}).call(this);

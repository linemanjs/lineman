/* jasmine-given - 2.6.1
 * Adds a Given-When-Then DSL to jasmine as an alternative style for specs
 * https://github.com/searls/jasmine-given
 */
/* jasmine-matcher-wrapper - 0.0.3
 * Wraps Jasmine 1.x matchers for use with Jasmine 2
 * https://github.com/testdouble/jasmine-matcher-wrapper
 */
(function() {
  var __hasProp = {}.hasOwnProperty,
    __slice = [].slice;

  (function(jasmine) {
    var comparatorFor, createMatcher;
    if (jasmine == null) {
      return typeof console !== "undefined" && console !== null ? console.warn("jasmine was not found. Skipping jasmine-matcher-wrapper. Verify your script load order.") : void 0;
    }
    if (jasmine.matcherWrapper != null) {
      return;
    }
    jasmine.matcherWrapper = {
      wrap: function(matchers) {
        var matcher, name, wrappedMatchers;
        if (jasmine.addMatchers == null) {
          return matchers;
        }
        wrappedMatchers = {};
        for (name in matchers) {
          if (!__hasProp.call(matchers, name)) continue;
          matcher = matchers[name];
          wrappedMatchers[name] = createMatcher(name, matcher);
        }
        return wrappedMatchers;
      }
    };
    createMatcher = function(name, matcher) {
      return function() {
        return {
          compare: comparatorFor(matcher, false),
          negativeCompare: comparatorFor(matcher, true)
        };
      };
    };
    return comparatorFor = function(matcher, isNot) {
      return function() {
        var actual, context, message, params, pass, _ref;
        actual = arguments[0], params = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        context = {
          actual: actual,
          isNot: isNot
        };
        pass = matcher.apply(context, params);
        if (isNot) {
          pass = !pass;
        }
        if (!pass) {
          message = (_ref = context.message) != null ? _ref.apply(context, params) : void 0;
        }
        return {
          pass: pass,
          message: message
        };
      };
    };
  })(jasmine || getJasmineRequireObj());

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function(jasmine) {
    var Waterfall, additionalInsightsForErrorMessage, apparentReferenceError, attemptedEquality, comparisonInsight, currentSpec, declareJasmineSpec, deepEqualsNotice, doneWrapperFor, evalInContextOfSpec, finalStatementFrom, getBlock, invariantList, mostRecentExpectations, mostRecentlyUsed, o, root, stringifyExpectation, wasComparison, whenList, wrapAsExpectations;
    mostRecentlyUsed = null;
    root = this;
    currentSpec = null;
    beforeEach(function() {
      return currentSpec = this;
    });
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
    root.Invariant = function() {
      var invariantBehavior;
      mostRecentlyUsed = root.Invariant;
      invariantBehavior = getBlock(arguments);
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
      return doneWrapperFor(setupFunction, function(done) {
        var context, result;
        context = currentSpec;
        result = setupFunction.call(context, done);
        if (assignResultTo) {
          if (!context[assignResultTo]) {
            return context[assignResultTo] = result;
          } else {
            throw new Error("Unfortunately, the variable '" + assignResultTo + "' is already assigned to: " + context[assignResultTo]);
          }
        }
      });
    };
    mostRecentExpectations = null;
    declareJasmineSpec = function(specArgs, itFunction) {
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
      itFunction("then " + (label != null ? label : stringifyExpectation(expectations)), function(jasmineDone) {
        var userCommands;
        userCommands = [].concat(whenList, invariantList, wrapAsExpectations(expectations));
        return new Waterfall(userCommands, jasmineDone).flow();
      });
      return {
        Then: subsequentThen,
        And: subsequentThen
      };
    };
    wrapAsExpectations = function(expectations) {
      var expectation, i, _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = expectations.length; _i < _len; i = ++_i) {
        expectation = expectations[i];
        _results.push((function(expectation, i) {
          return doneWrapperFor(expectation, function(maybeDone) {
            return expect(expectation).not.toHaveReturnedFalseFromThen(currentSpec, i + 1, maybeDone);
          });
        })(expectation, i));
      }
      return _results;
    };
    doneWrapperFor = function(func, toWrap) {
      if (func.length === 0) {
        return function() {
          return toWrap();
        };
      } else {
        return function(done) {
          return toWrap(done);
        };
      }
    };
    root.Then = function() {
      return declareJasmineSpec(arguments);
    };
    root.Then.only = function() {
      return declareJasmineSpec(arguments, it.only);
    };
    root.subsequentThen = function(additionalExpectation) {
      mostRecentExpectations.push(additionalExpectation);
      return this;
    };
    mostRecentlyUsed = root.Given;
    root.And = function() {
      return mostRecentlyUsed.apply(this, jasmine.util.argsToArray(arguments));
    };
    o = function(thing) {
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
    jasmine._given = {
      matchers: {
        toHaveReturnedFalseFromThen: function(context, n, done) {
          var e, exception, result;
          result = false;
          exception = void 0;
          try {
            result = this.actual.call(context, done);
          } catch (_error) {
            e = _error;
            exception = e;
          }
          this.message = function() {
            var msg, stringyExpectation;
            stringyExpectation = stringifyExpectation(this.actual);
            msg = "Then clause" + (n > 1 ? " #" + n : "") + " `" + stringyExpectation + "` failed by ";
            if (exception) {
              msg += "throwing: " + exception.toString();
            } else {
              msg += "returning false";
            }
            msg += additionalInsightsForErrorMessage(stringyExpectation);
            return msg;
          };
          return result === false;
        }
      }
    };
    stringifyExpectation = function(expectation) {
      var matches;
      matches = expectation.toString().replace(/\n/g, '').match(/function\s?\(.*\)\s?{\s*(return\s+)?(.*?)(;)?\s*}/i);
      if (matches && matches.length >= 3) {
        return matches[2].replace(/\s+/g, ' ');
      } else {
        return "";
      }
    };
    additionalInsightsForErrorMessage = function(expectationString) {
      var comparison, expectation;
      expectation = finalStatementFrom(expectationString);
      if (comparison = wasComparison(expectation)) {
        return comparisonInsight(expectation, comparison);
      } else {
        return "";
      }
    };
    finalStatementFrom = function(expectationString) {
      var multiStatement;
      if (multiStatement = expectationString.match(/.*return (.*)/)) {
        return multiStatement[multiStatement.length - 1];
      } else {
        return expectationString;
      }
    };
    wasComparison = function(expectation) {
      var comparator, comparison, left, right, s;
      if (comparison = expectation.match(/(.*) (===|!==|==|!=|>|>=|<|<=) (.*)/)) {
        s = comparison[0], left = comparison[1], comparator = comparison[2], right = comparison[3];
        return {
          left: left,
          comparator: comparator,
          right: right
        };
      }
    };
    comparisonInsight = function(expectation, comparison) {
      var left, msg, right;
      left = evalInContextOfSpec(comparison.left);
      right = evalInContextOfSpec(comparison.right);
      if (apparentReferenceError(left) && apparentReferenceError(right)) {
        return "";
      }
      msg = "\n\nThis comparison was detected:\n  " + expectation + "\n  " + left + " " + comparison.comparator + " " + right;
      if (attemptedEquality(left, right, comparison.comparator)) {
        msg += "\n\n" + (deepEqualsNotice(comparison.left, comparison.right));
      }
      return msg;
    };
    apparentReferenceError = function(result) {
      return /^<Error: "ReferenceError/.test(result);
    };
    evalInContextOfSpec = function(operand) {
      var e;
      try {
        return (function() {
          return eval(operand);
        }).call(currentSpec);
      } catch (_error) {
        e = _error;
        return "<Error: \"" + ((e != null ? typeof e.message === "function" ? e.message() : void 0 : void 0) || e) + "\">";
      }
    };
    attemptedEquality = function(left, right, comparator) {
      var _ref;
      if (!(comparator === "==" || comparator === "===")) {
        return false;
      }
      if (((_ref = jasmine.matchersUtil) != null ? _ref.equals : void 0) != null) {
        return jasmine.matchersUtil.equals(left, right);
      } else {
        return jasmine.getEnv().equals_(left, right);
      }
    };
    deepEqualsNotice = function(left, right) {
      return "However, these items are deeply equal! Try an expectation like this instead:\n  expect(" + left + ").toEqual(" + right + ")";
    };
    Waterfall = (function() {
      function Waterfall(functions, finalCallback) {
        var func, _i, _len, _ref;
        if (functions == null) {
          functions = [];
        }
        this.flow = __bind(this.flow, this);
        this.invokeFinalCallbackIfNecessary = __bind(this.invokeFinalCallbackIfNecessary, this);
        this.asyncTaskCompleted = __bind(this.asyncTaskCompleted, this);
        this.functions = functions.slice(0);
        this.finalCallback = finalCallback;
        this.asyncCount = 0;
        _ref = this.functions;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          func = _ref[_i];
          if (func.length > 0) {
            this.asyncCount += 1;
          }
        }
      }

      Waterfall.prototype.asyncTaskCompleted = function() {
        this.asyncCount -= 1;
        return this.flow();
      };

      Waterfall.prototype.invokeFinalCallbackIfNecessary = function() {
        if (this.asyncCount === 0) {
          if (typeof this.finalCallback === "function") {
            this.finalCallback();
          }
          return this.finalCallback = void 0;
        }
      };

      Waterfall.prototype.flow = function() {
        var func;
        if (this.functions.length === 0) {
          return this.invokeFinalCallbackIfNecessary();
        }
        func = this.functions.shift();
        if (func.length > 0) {
          return func(this.asyncTaskCompleted);
        } else {
          func();
          return this.flow();
        }
      };

      return Waterfall;

    })();
    return beforeEach(function() {
      if (jasmine.addMatchers != null) {
        return jasmine.addMatchers(jasmine.matcherWrapper.wrap(jasmine._given.matchers));
      } else {
        return this.addMatchers(jasmine._given.matchers);
      }
    });
  })(jasmine);

}).call(this);

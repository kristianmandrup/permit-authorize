// Generated by LiveScript 1.2.0
(function(){
  var requires, Matcher, expect;
  requires = require('../../../../requires');
  requires.test('test_setup');
  Matcher = requires.rule.container('matcher').RuleSubjectMatcher;
  expect = require('chai').expect;
  describe('RepoCleaner', function(){
    var matcher, createMatcher;
    createMatcher = function(subjects, debug){
      debug == null && (debug = true);
      return new Matcher(subjects);
    };
    return context('basic repo', function(){
      return before(function(){
        return matcher = createMatcher('my repo');
      });
    });
  });
}).call(this);

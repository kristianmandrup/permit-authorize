// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, Registrator, expect, createRegis;
  requires = require('../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  Registrator = requires.lib('rule').RuleRegistrator;
  expect = require('chai').expect;
  createRegis = function(debug){
    debug == null && (debug = true);
    return new Registrator({}, debug);
  };
  describe('RuleRegistrator', function(){
    var act, action, actions, subjects, registrator, container, book;
    return context('basic repo', function(){
      before(function(){
        container = {};
        registrator = createRegis();
        act = 'can';
        action = 'edit';
        actions = ['edit', 'publish'];
        return subjects = ['book', 'article'];
      });
      describe('add-rule (container, action, subjects)', function(){
        return specify('adds the rule to container', function(){
          return expect(registrator.addRule(container, action, subjects)).to.equal(registrator);
        });
      });
      describe('rule-extractor (rule-container, action, subjects)', function(){
        return specify('returns rule-extractor with extract function', function(){
          return expect(registrator.ruleExtractor(container, action, subjects).extract).to.be.an.instanceOf(Function);
        });
      });
      return describe('register-rule (act, actions, subjects)', function(){
        return specify('registers a rule', function(){
          var res;
          res = registrator.registerRule(act, actions, subjects);
          return expect(res).to.equal(registrator);
        });
      });
    });
  });
}).call(this);

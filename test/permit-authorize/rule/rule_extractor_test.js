// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, RuleExtractor, expect;
  requires = require('../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  RuleExtractor = requires.lib('rule').RuleExtractor;
  expect = require('chai').expect;
  describe('RepoRegistrator', function(){
    var extractor, createExtr;
    createExtr = function(container, action, subjects){
      return new RepoExtractor(container, action, subjects);
    };
    describe('create', function(){
      describe('invalid', function(){
        return specify('throws', function(){
          return expect(function(){
            return createExtr({}, 'ax');
          }).to['throw'];
        });
      });
      return describe('valid', function(){});
    });
    context('valid extractor', function(){
      return before(function(){
        return extractor = createExtr({}, 'edit', 'Article');
      });
    });
    describe('extract', function(){});
    describe('register-action-subjects (action-container, subjects)', function(){});
    describe('unique-subjects', function(){});
    describe('action-subjects', function(){});
    describe('rule-subjects', function(){});
    return describe('__rule-subjects', function(){});
  });
}).call(this);

// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, RuleMatcher, createMatcher, expect;
  requires = require('../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  RuleMatcher = require('../../../../rule').RuleMatcher;
  createMatcher = function(act, ar){
    return new RuleMatcher(act, ar);
  };
  expect = require('chai').expect;
  describe('RuleMatcher', function(){
    var subjects, ar;
    subjects = {};
    ar = {};
    return describe('create', function(){
      context('invalid', function(){
        return specify('throws', function(){
          return expect(function(){
            return createMatcher('can', {});
          }).to['throw'];
        });
      });
      context('valid', function(){
        specify('ok', function(){
          return expect(function(){
            return createMatcher('can', {});
          }).to.not['throw'];
        });
        return specify('act is camel cased', function(){
          return createMatcher('can', {}).act.should.eql('Act');
        });
      });
      context('valid matcher', function(){
        var matcher;
        return before(function(){
          subjects.book = {
            name: 'a nice journey',
            _class: 'Book'
          };
          subjects.movie = {
            name: 'The Apollo moonlanding scam!',
            _class: 'Movie',
            type: 'documentary'
          };
          ar.book = {
            user: 'kris',
            action: 'read',
            subject: subjects.book
          };
          return matcher = createMatcher('can', ar.book);
        });
      });
      describe('manage-actions', function(){
        return specify('has CED actions', function(){
          return matcher.manageActions.should.eql(['create', 'edit', 'delete']);
        });
      });
      describe('container-for', function(){});
      describe('rule-container', function(){});
      describe('match-subject-clazz (action-subjects, subj-clazz)', function(){});
      describe('match-manage-rule (rule-container, subj-clazz)', function(){});
      describe('manage-action-subjects (rule-container)', function(){});
      return describe('match', function(){});
    });
  });
}).call(this);

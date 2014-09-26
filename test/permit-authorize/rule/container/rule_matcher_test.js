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
      describe('container-for', function(){
        return specify('creates container', function(){
          return matcher.containerFor('edit').should;
        });
      });
      describe('rule-container', function(){
        return specify('creates container', function(){
          return matcher.ruleContainer('edit').should;
        });
      });
      describe('match-subject-clazz (action-subjects, subj-clazz)', function(){
        return specify('creates container', function(){
          return matcher.matchSubjectClazz(['article', 'book', 'movie'], 'book').should.eql('book');
        });
      });
      describe('match-manage-rule (container, subj-clazz)', function(){
        return specify('matches', function(){
          return matcher.matchSubjectClazz({
            manage: ['book']
          }, 'book').should.eql('edit');
        });
      });
      describe('manage-action-subjects (rule-container)', function(){
        return specify('manages', function(){
          return matcher.manageActionSubjects({
            manage: ['book']
          }).should.eql(true);
        });
      });
      return describe('match', function(){
        return specify('matches', function(){
          return matcher.match().should.eql(true);
        });
      });
    });
  });
}).call(this);
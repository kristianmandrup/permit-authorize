// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, RuleRepo, RepoRegistrator, expect;
  requires = require('../../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  RuleRepo = requires.rule('repo/rule_repo');
  RepoRegistrator = requires.rule('repo').RepoRegistrator;
  expect = require('chai').expect;
  describe('RepoRegistrator', function(){
    var accessRequest, rule, repo, book, can, cannot, createRepo;
    createRepo = function(name, debug){
      return new RuleRepo(name, debug);
    };
    return context('basic repo', function(){
      return before(function(){
        return repo = createRepo('my repo');
      });
    });
  });
}).call(this);

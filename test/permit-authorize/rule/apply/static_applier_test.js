// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, StaticApplier, RuleRepo;
  requires = require('../../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  console.log(requires.rule);
  StaticApplier = requires.rule('apply').StaticApplier;
  RuleRepo = requires.rule('repo').RuleRepo;
  describe('StaicApplier', function(){
    var book, ruleRepo, ruleApplier, rules, createRepo, applier, createRuleApplier, execRuleApplier;
    rules = {};
    createRepo = function(name, debug){
      name == null && (name = 'static repo');
      debug == null && (debug = true);
      return new RuleRepo(name, debug).clear();
    };
    applier = function(repo, rules, debug){
      return new StaticApplier(repo, rules, debug);
    };
    createRuleApplier = function(rules, actionRequest){
      ruleRepo = createRepo();
      return ruleApplier = applier(ruleRepo, rules, true);
    };
    execRuleApplier = function(rules, actionRequest){
      return ruleApplier = createRuleApplier(rules, actionRequest).applyRules();
    };
    before(function(){
      return book = new Book('Far and away');
    });
    describe('manage paper', function(){
      return context('applied default rule: manage Paper', function(){
        before(function(){
          rules.managePaper = {
            'default': function(){
              return this.ucan('manage', 'Paper');
            }
          };
          return execRuleApplier(rules.managePaper);
        });
        return specify('should add create, edit and delete can-rules', function(){
          return ruleRepo.canRules.should.eql({
            manage: ['Paper'],
            create: ['Paper'],
            edit: ['Paper'],
            'delete': ['Paper']
          });
        });
      });
    });
    return describe('apply-rules', function(){
      return describe('static', function(){
        var readAccessRequest, ruleRepo, ruleApplier, rules;
        before(function(){
          rules = {
            edit: function(){
              this.ucan('edit', 'Book');
              return this.ucannot('write', 'Book');
            },
            read: function(){
              this.ucan('read', 'Project');
              return this.ucannot('delete', 'Paper');
            },
            'default': function(){
              return this.ucan('read', 'Paper');
            }
          };
          readAccessRequest = {
            action: 'read',
            subject: book
          };
          ruleRepo = createRepo().clear();
          ruleApplier = createRulesApplier(ruleRepo, rules);
          return ruleApplier.applyRules();
        });
        specify('adds all static can rules', function(){
          return ruleRepo.canRules.should.be.eql({
            read: ['Paper']
          });
        });
        return specify('adds all static cannot rules', function(){
          return ruleRepo.cannotRules.should.be.eql({});
        });
      });
    });
  });
}).call(this);

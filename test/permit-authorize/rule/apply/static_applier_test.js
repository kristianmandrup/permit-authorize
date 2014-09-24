// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, RulesApplier, ExecutionContext, RuleRepo;
  requires = require('../../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  console.log(requires.rule);
  RulesApplier = requires.rule('apply').StaticApplier;
  ExecutionContext = requires.rule('apply').ExecutionContext;
  RuleRepo = requires.rule('repo').RuleRepo;
  describe('StaicApplier', function(){
    var book, ruleRepo, ruleApplier, rules, applier, createRepo, createExecCtx, createRuleApplier, execRuleApplier;
    rules = {};
    applier = function(ctx, rules, debug){
      debug == null && (debug = true);
      return new RulesApplier(ctx, rules, debug);
    };
    createRepo = function(name, debug){
      name == null && (name = 'dynamic repo');
      debug == null && (debug = false);
      return new RuleRepo(name, debug).clear();
    };
    createExecCtx = function(debug){
      debug == null && (debug = true);
      return new ExecutionContext(createRepo(), debug);
    };
    createRuleApplier = function(rules){
      return applier(createExecCtx(), rules, true);
    };
    execRuleApplier = function(rules, actionRequest){
      return createRuleApplier(rules).applyRules();
    };
    before(function(){
      return book = new Book('Far and away');
    });
    return describe('manage paper', function(){
      context('applied default rule: manage Paper', function(){
        before(function(){
          rules.managePaper = {
            'default': function(){
              return this.ucan('manage', 'Paper');
            }
          };
          ruleApplier = execRuleApplier(rules.managePaper);
          return ruleRepo = ruleApplier.repo();
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
      return describe('apply-rules', function(){
        return describe('static', function(){
          var ruleRepo, ruleApplier, rules;
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
            ruleApplier = execRuleApplier(rules);
            return ruleRepo = ruleApplier.repo();
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
  });
}).call(this);

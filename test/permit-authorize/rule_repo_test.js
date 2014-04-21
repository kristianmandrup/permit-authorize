// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, RuleRepo;
  requires = require('../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  RuleRepo = requires.rule('rule_repo');
  describe('Rule Repository (RuleRepo)', function(){
    var accessRequest, rule, ruleRepo, book, can, cannot;
    context('basic repo', function(){
      before(function(){
        return ruleRepo = new RuleRepo;
      });
      specify('has can-rules', function(){
        return ruleRepo.canRules.should.be.an['instanceof'](Object);
      });
      specify('has cannot-rules', function(){
        return ruleRepo.canRules.should.be.an['instanceof'](Object);
      });
      describe('container-for', function(){
        specify('can', function(){
          return ruleRepo.containerFor('can').should.eql(ruleRepo.canRules);
        });
        return specify('cannot', function(){
          return ruleRepo.containerFor('cannot').should.eql(ruleRepo.cannotRules);
        });
      });
      describe('register-rule', function(){
        before(function(){
          return ruleRepo.clean();
        });
        specify('can register a valid rule', function(){
          ruleRepo.registerRule('can', 'read', 'Book');
          ruleRepo.should.have.property('canRules');
          return ruleRepo.canRules.should.eql({
            'read': ['Book']
          });
        });
        return specify('throws error on invalid rule', function(){
          return function(){
            return ruleRepo.registerRule('can', 'read', null);
          }.should['throw']();
        });
      });
      describe('add-rule', function(){
        context('valid', function(){
          before(function(){
            var container;
            ruleRepo.clean();
            container = ruleRepo.canRules;
            return ruleRepo.addRule(container, 'read', 'Book');
          });
          return specify('can-rules contains read book rule', function(){
            return ruleRepo.canRules.should.eql({
              'read': ['Book']
            });
          });
        });
        return context('invalid', function(){
          specify('throws error if container is null', function(){
            return function(){
              return ruleRepo.addRule(null, 'read', 'Book');
            }.should['throw']();
          });
          return specify('throws error if container is not an Object', function(){
            return function(){
              return ruleRepo.addRule([], 'read', 'Book');
            }.should['throw']();
          });
        });
      });
      return describe('find-matching-subject', function(){
        var books;
        before(function(){
          ruleRepo.clean();
          book = new Book({
            title: 'hi molly'
          });
          return books = ['Book', void 8];
        });
        specify('matches book on list of books', function(){
          return ruleRepo.findMatchingSubject(books, 'book').should.be['true'];
        });
        specify('matches Book on list of books', function(){
          return ruleRepo.findMatchingSubject(books, 'Book').should.be['true'];
        });
        return specify('does not match BoAk on list of books', function(){
          return ruleRepo.findMatchingSubject(books, 'BoAk').should.be['false'];
        });
      });
    });
    return xdescribe('match-rule', function(){
      return context('can-rules - read book', function(){
        before(function(){
          return ruleRepo.canRules = {
            'read': ['Book']
          };
        });
        specify('can find rule that allows user to read a book', function(){
          var readBookRule;
          readBookRule = {
            action: 'read',
            subject: 'Book'
          };
          return ruleRepo.matchRule('can', readBookRule).should.be['true'];
        });
        return specify('can NOT find rule that allows user to publish a book', function(){
          var publishBookRule;
          publishBookRule = {
            action: 'publish',
            subject: 'Book'
          };
          return ruleRepo.matchRule('can', publishBookRule).should.be['false'];
        });
      });
    });
  });
}).call(this);

// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, createUser, createPermit, createRequest, Allower, Permit, PermitRegistry, permitFor, expect;
  requires = require('../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  createUser = requires.fac('create-user');
  createPermit = requires.fac('create-permit');
  createRequest = requires.fac('create-request');
  Allower = requires.lib('allower').Allower;
  Permit = requires.lib('permit').Permit;
  PermitRegistry = requires.permit('registry').PermitRegistry;
  permitFor = requires.permit('factory').permitFor;
  expect = require('chai').expect;
  describe('Allower', function(){
    var book, allowers, users, requests, permits, bookAccess, allower;
    allowers = {};
    users = {};
    requests = {};
    permits = {};
    bookAccess = function(action, user){
      return {
        user: user,
        action: action,
        subject: book
      };
    };
    allower = function(request){
      return new Allower(request);
    };
    before(function(){
      users.kris = createUser.kris();
      users.guest = createUser.guest();
      users.admin = createUser.admin();
      users.editor = createUser.role('editor');
      return book = new Book({
        title: 'to the moon and back'
      });
    });
    describe('read-book-allower', function(){
      before(function(){
        requests.readBook = bookAccess('read', users.guest);
        return allowers.readBook = new Allower(requests.readBook);
      });
      specify('return Allower instance', function(){
        return allowers.readBook.constructor.should.eql(Allower);
      });
      return specify('Allower sets own access obj', function(){
        return allowers.readBook.accessRequest.should.eql(requests.readBook);
      });
    });
    return describe('allows and disallows', function(){
      before(function(){
        Permit.registry.clean();
        permits.user = permitFor('User', {
          match: function(access){
            return this.matching(access).user();
          },
          rules: function(){
            return this.ucan('view', 'book');
          }
        });
        permits.guest = permitFor('Guest', {
          match: function(access){
            return this.matching(access).role('guest');
          },
          rules: function(){
            this.ucan('read', 'book');
            return this.ucannot('write', 'book');
          }
        });
        permits.editor = permitFor('Editor', {
          match: function(access){
            return this.matching(access).role('editor');
          },
          rules: function(){
            return this.ucan(['read', 'write'], 'book');
          }
        });
        requests.readBook = bookAccess('read', users.guest);
        requests.writeBook = bookAccess('write', users.editor);
        requests.notWriteBook = bookAccess('write', users.guest);
        allowers.readBook = allower(requests.readBook);
        allowers.writeBook = allower(requests.writeBook);
        allowers.notWriteBook = allower(requests.notWriteBook);
        return allowers.readBook.debugOn();
      });
      describe('allows!', function(){
        beforeEach(function(){
          return Permit.registry.cleanPermits();
        });
        specify('read a book access should be allowed', function(){
          return expect(allowers.readBook.allows()).to.be['true'];
        });
        xspecify('Editor write a book should be allowed', function(){
          return expect(allowers.writeBook.allows()).to.be['true'];
        });
        return xspecify('Guest write a book should NOT be allowed', function(){
          return expect(allowers.notWriteBook.allows()).to.be['false'];
        });
      });
      return xdescribe('disallows!', function(){
        beforeEach(function(){
          return Permit.registry.cleanPermits();
        });
        specify('Guest read a book access should NOT be disallowed', function(){
          return allowers.readBook.disallows().should.be['false'];
        });
        return specify('Editor write a book should NOT be disallowed', function(){
          return allowers.writeBook.disallows().should.be['false'];
        });
      });
    });
  });
}).call(this);

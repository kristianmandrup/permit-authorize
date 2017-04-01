// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, createUser, createRequest, createPermit, Permit, PermitRegistry, permitFor, PermitFilter;
  requires = require('../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  createUser = requires.fac('create-user');
  createRequest = requires.fac('create-request');
  createPermit = requires.fac('create-permit');
  Permit = requires.lib('permit');
  PermitRegistry = requires.permit('permit_registry');
  permitFor = requires.permit('permit_for');
  PermitFilter = requires.permit('permit_filter');
  describe('permit-filter', function(){
    var permits, users, requests;
    permits = {};
    users = {};
    requests = {};
    describe('user filter', function(){
      before(function(){
        users.javier = createUser.javier();
        requests.user = {
          user: users.javier
        };
        PermitRegistry.clearAll();
        return permits.user = createPermit.matching.user();
      });
      return specify('return only permits that apply for a user', function(){
        return PermitFilter.filter(requests.user).should.eql([permits.user]);
      });
    });
    describe('guest user filter', function(){
      before(function(){
        PermitRegistry.clearAll();
        users.guest = createUser.guest();
        requests.guest = {
          user: users.guest
        };
        return permits.guest = createPermit.matching.role.guest();
      });
      return specify('return only permits that apply for a guest user', function(){
        return PermitFilter.filter(requests.guest).should.eql([permits.guest]);
      });
    });
    return describe('admin user filter', function(){
      before(function(){
        users.admin = createUser.admin();
        requests.admin = {
          user: users.admin
        };
        return permits.admin = createPermit.matching.role.admin();
      });
      return specify('return only permits that apply for an admin user', function(){
        return PermitFilter.filter(requests.admin).should.eql([permits.admin]);
      });
    });
  });
}).call(this);
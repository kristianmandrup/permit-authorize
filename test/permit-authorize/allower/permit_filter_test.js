// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, createUser, createRequest, createPermit, Permit, PermitRegistry, permitFor, PermitFilter, createFilter;
  requires = require('../../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  createUser = requires.fac('create-user');
  createRequest = requires.fac('create-request');
  createPermit = requires.fac('create-permit');
  Permit = requires.lib('permit').Permit;
  PermitRegistry = requires.permit('registry').PermitRegistry;
  permitFor = requires.permit('factory').permitFor;
  PermitFilter = requires.lib('allower').PermitFilter;
  createFilter = function(ar, debug){
    debug == null && (debug = true);
    return new PermitFilter(ar, debug);
  };
  describe('permit-filter', function(){
    var pf, permits, users, requests;
    permits = {};
    users = {};
    requests = {};
    describe('user filter', function(){
      before(function(){
        users.javier = createUser.javier();
        requests.user = {
          user: users.javier
        };
        Permit.registry.clean();
        permits.user = createPermit.matching.user();
        return pf = createFilter(requests.user);
      });
      return specify('return only permits that apply for a user', function(){
        return pf.filter().should.eql([permits.user]);
      });
    });
    xdescribe('guest user filter', function(){
      before(function(){
        Permit.registry.clean();
        users.guest = createUser.guest();
        requests.guest = {
          user: users.guest
        };
        return permits.guest = createPermit.matching.role.guest();
      });
      return specify('return only permits that apply for a guest user', function(){
        return pf.filter(requests.guest).should.eql([permits.guest]);
      });
    });
    return xdescribe('admin user filter', function(){
      before(function(){
        users.admin = createUser.admin();
        requests.admin = {
          user: users.admin
        };
        return permits.admin = createPermit.matching.role.admin();
      });
      return specify('return only permits that apply for an admin user', function(){
        return pf.filter(requests.admin).should.eql([permits.admin]);
      });
    });
  });
}).call(this);

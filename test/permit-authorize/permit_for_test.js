// Generated by LiveScript 1.2.0
(function(){
  var requires, User, Book, Permit, PermitRegistry, permitFor, AdminPermit;
  requires = require('../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  Book = requires.fix('book');
  Permit = requires.lib('permit');
  PermitRegistry = requires.permit('permit_registry');
  permitFor = requires.permit('permit_for');
  AdminPermit = (function(superclass){
    var prototype = extend$((import$(AdminPermit, superclass).displayName = 'AdminPermit', AdminPermit), superclass).prototype, constructor = AdminPermit;
    prototype.type = 'admin';
    function AdminPermit(){
      AdminPermit.superclass.apply(this, arguments);
    }
    return AdminPermit;
  }(Permit));
  describe('permit-for', function(){
    var permits;
    permits = {};
    context('multiple guest permits', function(){
      before(function(){
        return permits.guest = permitFor('Guest', {
          number: 1,
          match: function(access){
            return this.matching(access).role('guest');
          }
        });
      });
      specify('guest permit is a Permit', function(){
        return permits.guest.constructor.should.eql(Permit);
      });
      specify('guest permit name is Guest', function(){
        return permits.guest.name.should.eql('Guest');
      });
      return specify('creating other Guest permit throws error', function(){
        return function(){
          return permitFor('Guest');
        }.should['throw'];
      });
    });
    return context('one admin permit', function(){
      var adminPermit;
      before(function(){
        PermitRegistry.clearAll();
        return adminPermit = permitFor(AdminPermit, 'Admin', {
          rules: {
            admin: function(){
              return this.ucan('manage', 'all');
            }
          }
        });
      });
      specify('creates a permit', function(){
        return adminPermit.constructor.should.eql(AdminPermit);
      });
      specify('has the name Admin', function(){
        return adminPermit.name.should.eql('Admin');
      });
      specify('has the type Admin', function(){
        return adminPermit.type.should.eql('admin');
      });
      return specify('sets rules to run', function(){
        return adminPermit.rules.should.be.an.instanceOf(Object);
      });
    });
  });
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);

// Generated by LiveScript 1.2.0
(function(){
  var requires, Permit, PermitFactory, AdminPermit, expect, toString$ = {}.toString;
  requires = require('../../../../requires');
  requires.test('test_setup');
  Permit = requires.lib('permit').Permit;
  PermitFactory = requires.permit('factory').PermitFactory;
  AdminPermit = (function(superclass){
    var prototype = extend$((import$(AdminPermit, superclass).displayName = 'AdminPermit', AdminPermit), superclass).prototype, constructor = AdminPermit;
    prototype.type = 'admin';
    function AdminPermit(){
      AdminPermit.superclass.apply(this, arguments);
    }
    return AdminPermit;
  }(Permit));
  expect = require('chai').expect;
  describe('PermitFactory', function(){
    var permits, fun;
    permits = {};
    describe('create with function', function(){
      beforeEach(function(){
        fun = function(){
          return {
            rules: {
              ctx: {
                area: {
                  visitor: function(){
                    return this.ucan('publish', 'Paper');
                  }
                }
              },
              read: function(){
                return this.ucan('read', 'Book');
              },
              write: function(){
                return this.ucan('write', 'Book');
              },
              'default': function(){
                return this.ucan('read', 'any');
              }
            }
          };
        };
        return permits.funGuest = new PermitFactory('guest books', fun, false).create();
      });
      return describe('rules', function(){
        specify('should be an object', function(){
          return expect(toString$.call(permits.funGuest.rules).slice(8, -1)).to.eql('Object');
        });
        return specify('read be a Function', function(){
          return expect(toString$.call(permits.funGuest.rules.read).slice(8, -1)).to.eql('Function');
        });
      });
    });
    return context('multiple guest permits', function(){
      before(function(){
        return permits.guest = new PermitFactory('Guest', {
          number: 1,
          match: function(access){
            return this.matching(access).role('guest');
          }
        }).create();
      });
      specify('guest permit is a Permit', function(){
        return permits.guest.constructor.displayName.should.eql('Permit');
      });
      specify('guest permit name is Guest', function(){
        return permits.guest.name.should.eql('Guest');
      });
      specify('creating other Guest permit throws error', function(){
        return function(){
          return permitFor('Guest');
        }.should['throw'];
      });
      describe('use', function(){});
      return describe('create', function(){});
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

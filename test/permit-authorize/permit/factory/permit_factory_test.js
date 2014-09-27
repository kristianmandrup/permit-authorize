// Generated by LiveScript 1.2.0
(function(){
  var requires, Permit, PermitFactory, AdminPermit;
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
  describe('PermitFactory', function(){
    var permits;
    permits = {};
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
      return specify('creating other Guest permit throws error', function(){
        return function(){
          return permitFor('Guest');
        }.should['throw'];
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
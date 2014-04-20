// Generated by LiveScript 1.2.0
(function(){
  var requires, User, intersect;
  requires = require('../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  intersect = requires.util('intersect')();
  describe('Intersect', function(){
    var krisUser, guestUser, adminUser, krisAdminUser;
    before(function(){
      krisUser = new User({
        name: 'kris'
      });
      guestUser = new User({
        role: 'guest'
      });
      adminUser = new User({
        role: 'admin'
      });
      return krisAdminUser = new User({
        name: 'kris',
        role: 'admin'
      });
    });
    return describe('on', function(){
      specify('does NOT intersects on object with no overlap', function(){
        return intersect.on({
          user: 'x'
        }, {
          user: 'y'
        }).should.be['false'];
      });
      specify('does NOT intersects on users with no overlap', function(){
        return intersect.on({
          user: krisUser
        }, {
          user: guestUser
        }).should.be['false'];
      });
      specify('intersects on same object', function(){
        return intersect.on({
          user: krisUser
        }, {
          user: krisUser
        }).should.be['true'];
      });
      specify('does NOT intersects when partial is > obj', function(){
        return intersect.on({
          user: krisAdminUser
        }, {
          user: adminUser
        }).should.be['false'];
      });
      return specify('intersects on object with partial overlap on target obj', function(){
        return intersect.on({
          user: adminUser
        }, {
          user: krisAdminUser
        }).should.be['true'];
      });
    });
  });
}).call(this);

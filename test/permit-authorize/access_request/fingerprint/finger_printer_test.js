// Generated by LiveScript 1.2.0
(function(){
  var requires, Book, AccessRequest, fingerprint, FingerPrinter;
  requires = require('../../../../requires');
  requires.test('test_setup');
  Book = requires.fix('book');
  AccessRequest = requires.lib('access-request').AccessRequest;
  fingerprint = requires.lib('access-request').fingerprint;
  FingerPrinter = fingerprint.FingerPrinter;
  describe('FingerPrinter', function(){
    var accessRequest, fingerPrinter;
    fingerPrinter = function(ar, debug){
      debug == null && (debug = true);
      return new FingerPrinter(ar, debug);
    };
    before(function(){
      return accessRequest = {
        user: {
          name: 'Kris'
        },
        action: 'read'
      };
    });
    return describe('fingerprint', function(){
      return specify('has method access-hash', function(){
        var res;
        res = fingerPrinter(accessRequest).fingerprint();
        console.log(res);
        return res.should.eql(ea4fd60a6dc4c0f9b0cc7637f7f5617e);
      });
    });
  });
}).call(this);
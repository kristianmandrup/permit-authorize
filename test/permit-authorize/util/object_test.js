// Generated by LiveScript 1.2.0
(function(){
  var requires, object, Debugger;
  requires = require('../../../requires');
  requires.test('test_setup');
  object = requires.util('object');
  Debugger = requires.util('debugger');
  describe('util', function(){
    return describe('object', function(){
      return describe('values', function(){
        return specify('should create unique array', function(){
          return object.values({
            a: 'x',
            b: 'y'
          }).should.eql(['x', 'y']);
        });
      });
    });
  });
}).call(this);

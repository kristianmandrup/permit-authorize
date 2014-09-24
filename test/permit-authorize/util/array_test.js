// Generated by LiveScript 1.2.0
(function(){
  var requires, array, Debugger;
  requires = require('../../../requires');
  requires.test('test_setup');
  array = requires.util('array');
  Debugger = requires.util('debugger');
  describe('util', function(){
    return describe('array', function(){
      describe('unique', function(){
        return specify('should create unique array', function(){
          return array.unique([1, 2, 1, 3, 2]).should.eql([1, 3, 2]);
        });
      });
      describe('contains', function(){
        return specify('should find matching elem', function(){
          return array.contains([1, 2, 1, 'x', 2], 'x').should.eql(true);
        });
      });
      return describe('flatten', function(){
        return specify('should flatten array', function(){
          return array.flatten([1, 2, [1, 3], 2]).should.eql([1, 2, 1, 3, 2]);
        });
      });
    });
  });
}).call(this);
// Generated by LiveScript 1.2.0
(function(){
  var requires, User, normalize;
  requires = require('../../requires');
  requires.test('test_setup');
  User = requires.fix('user');
  normalize = requires.util('normalize');
  describe('normalize', function(){
    var fun, str, list, funList, nestedFun;
    before(function(){
      fun = function(){
        return ["xyz"];
      };
      str = "abc";
      list = ['a', 'b'];
      funList = ["abc", fun];
      return nestedFun = function(){
        return funList;
      };
    });
    describe('Function', function(){
      return specify('is called', function(){
        return normalize(fun).should.eql(["xyz"]);
      });
    });
    describe('String', function(){
      return specify('wrapped in array', function(){
        return normalize(str).should.eql([str]);
      });
    });
    describe('Array', function(){
      return specify('returned', function(){
        return normalize(list).should.eql(list);
      });
    });
    describe('Array with function', function(){
      return specify('normalize function', function(){
        return normalize(funList).should.eql(["abc", "xyz"]);
      });
    });
    describe('Number', function(){
      return specify('throws error', function(){
        return function(){
          return normalize(3);
        }.should['throw']();
      });
    });
    return describe('Nested Functions', function(){
      return specify('normalized to single array', function(){
        return normalize(nestedFun).should.eql(["abc", "xyz"]);
      });
    });
  });
}).call(this);

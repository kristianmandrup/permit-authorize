// Generated by LiveScript 1.2.0
(function(){
  var requires, lo, Debugger, TestDebug;
  requires = require('../../requires');
  requires.test('test_setup');
  lo = require('lodash');
  Debugger = requires.lib('debugger');
  TestDebug = (function(){
    TestDebug.displayName = 'TestDebug';
    var prototype = TestDebug.prototype, constructor = TestDebug;
    importAll$(prototype, arguments[0]);
    function TestDebug(){
      TestDebug.superclass;
    }
    TestDebug.clazzMeth = function(){
      return this.debug("clazz-meth", "called");
    };
    prototype.instMeth = function(){
      return this.debug("inst-meth", "called");
    };
    return TestDebug;
  }(Debugger));
  lo.extend(TestDebug, Debugger);
  describe('Debugger', function(){
    describe('class level', function(){
      describe('defaults', function(){
        return specify('debugging should be off', function(){
          return TestDebug.debugging.should.eql(false);
        });
      });
      describe('debug-on', function(){
        before(function(){
          return TestDebug.debugOn();
        });
        return specify('debugging should be on', function(){
          return TestDebug.debugging.should.eql(true);
        });
      });
      describe('debug-off', function(){
        before(function(){
          TestDebug.debugOn();
          return TestDebug.debugOff();
        });
        return specify('debugging should be on', function(){
          return TestDebug.debugging.should.eql(false);
        });
      });
      return describe('debug', function(){
        context('debugging off', function(){
          return specify('does NOT prints a msg to console', function(){
            return TestDebug.debug('not', 'printed');
          });
        });
        return context('debugging on', function(){
          before(function(){
            return TestDebug.debugOn();
          });
          return specify('prints a msg to console', function(){
            return TestDebug.debug('is', 'printed');
          });
        });
      });
    });
    return describe('instance level', function(){
      var testDebug;
      before(function(){
        return testDebug = new TestDebug;
      });
      describe('defaults', function(){
        return specify('debugging should be off', function(){
          return testDebug.debugging.should.eql(false);
        });
      });
      describe('debug-on', function(){
        before(function(){
          return testDebug.debugOn();
        });
        return specify('debugging should be on', function(){
          return testDebug.debugging.should.eql(true);
        });
      });
      describe('debug-off', function(){
        before(function(){
          testDebug.debugOn();
          return testDebug.debugOff();
        });
        return specify('debugging should be on', function(){
          return testDebug.debugging.should.eql(false);
        });
      });
      return describe('debug', function(){
        context('debugging off', function(){
          return specify('does NOT prints a msg to console', function(){
            return testDebug.debug('not', 'printed');
          });
        });
        return context('debugging on', function(){
          before(function(){
            return testDebug.debugOn();
          });
          return specify('prints a msg to console', function(){
            return testDebug.debug('is', 'printed');
          });
        });
      });
    });
  });
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);

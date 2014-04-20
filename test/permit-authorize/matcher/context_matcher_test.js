// Generated by LiveScript 1.2.0
(function(){
  var requires, ability, matchers, ContextMatcher;
  requires = require('../../../requires');
  requires.test('test_setup');
  ability = require('../ability/abilities');
  matchers = requires.lib('matchers');
  ContextMatcher = matchers.ContextMatcher;
  describe('ContextMatcher', function(){
    var ctxMatcher, areaCtx, requests;
    requests = {};
    before(function(){
      areaCtx = {
        area: 'visitor'
      };
      return requests.visitor = {
        ctx: areaCtx
      };
    });
    describe('create', function(){
      beforeEach(function(){
        return ctxMatcher = new ContextMatcher(requests.visitor);
      });
      return specify('must have admin access request', function(){
        return ctxMatcher.accessRequest.should.eql(requests.visitor);
      });
    });
    describe('match', function(){
      beforeEach(function(){
        return ctxMatcher = new ContextMatcher(requests.visitor);
      });
      specify('should match area: visitor', function(){
        return ctxMatcher.match(areaCtx).should.be['true'];
      });
      specify('should NOT match area: member', function(){
        return ctxMatcher.match({
          area: 'member'
        }).should.be['false'];
      });
      return specify('should match on no argument', function(){
        return ctxMatcher.match().should.be['true'];
      });
    });
    return describe('match function', function(){
      beforeEach(function(){
        requests.visitor = {
          ctx: {
            auth: 'yes'
          }
        };
        return ctxMatcher = new ContextMatcher(requests.visitor);
      });
      return specify('should match -> auth is yes', function(){
        return ctxMatcher.match(function(){
          return this.auth === 'yes';
        }).should.be['true'];
      });
    });
  });
}).call(this);

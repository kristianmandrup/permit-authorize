// Generated by LiveScript 1.2.0
(function(){
  var PermitMatcher, AccessMatcher, mh, MatchHelper, accessMatcherDelegates, i$, len$, name;
  PermitMatcher = require('./permit_matcher');
  AccessMatcher = require('../../access_request').matcher.AccessMatcher;
  mh = MatchHelper = (function(){
    MatchHelper.displayName = 'MatchHelper';
    var prototype = MatchHelper.prototype, constructor = MatchHelper;
    function MatchHelper(context, accessRequest){
      this.context = context;
      this.accessRequest = accessRequest;
    }
    prototype.matching = function(){
      var fingerprint;
      fingerprint = accessRequest.fingerprint();
      if (!this.cached_matchers[fingerprint]) {
        this.cached_matchers[fingerprint] = new AccessMatcher(accessRequest);
      }
      return this.cached_matchers[fingerprint];
    };
    return MatchHelper;
  }());
  accessMatcherDelegates = ['match-on', 'user', 'role', 'roles', 'subject', 'subject-clazz', 'action', 'context', 'ctx'];
  module.exports = mh;
  for (i$ = 0, len$ = accessMatcherDelegates.length; i$ < len$; ++i$) {
    name = accessMatcherDelegates[i$];
    mh[name] = fn$;
  }
  function fn$(accessRequest, value){
    return this.matching(accessRequest)[helper](value);
  }
}).call(this);
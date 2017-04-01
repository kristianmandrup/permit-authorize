// Generated by LiveScript 1.2.0
(function(){
  var lo, Intersect, AccessMatcher, Debugger, PermitMatcher, toString$ = {}.toString;
  lo = require('../util/lodash_lite');
  Intersect = require('../util/intersect');
  AccessMatcher = require('../matcher/access_matcher');
  Debugger = require('../debugger');
  module.exports = PermitMatcher = (function(){
    PermitMatcher.displayName = 'PermitMatcher';
    var prototype = PermitMatcher.prototype, constructor = PermitMatcher;
    importAll$(prototype, arguments[0]);
    function PermitMatcher(permit, accessRequest, debugging){
      this.permit = permit;
      this.accessRequest = accessRequest;
      this.debugging = debugging;
      this.intersect = Intersect();
      if (this.debugging) {
        this.debugOn();
      }
      this.validate();
    }
    prototype.match = function(options){
      var res, mc;
      options == null && (options = {});
      this.debug('permit-matcher match');
      res = (this.include() || this.customMatch()) && !(this.exclude() || this.customExMatch());
      if (options.compiled === false) {
        return res;
      }
      this.debug('compiled result:', this.matchCompiled());
      mc = this.matchCompiled();
      this.debug('mc res', mc);
      return res || mc;
    };
    prototype.matchCompiled = function(){
      var res, i$, ref$, len$, matchFun;
      this.debug("match-compiled", this.permit.compiledList);
      if (toString$.call(this.permit.compiledList).slice(8, -1) !== 'Array') {
        return false;
      }
      this.debug("compiled matchers: " + this.permit.compiledList.length);
      res = false;
      for (i$ = 0, len$ = (ref$ = this.permit.compiledList).length; i$ < len$; ++i$) {
        matchFun = ref$[i$];
        if (matchFun(this.accessRequest)) {
          res = true;
        }
        this.debug('compile fun res', res);
        if (res) {
          break;
        }
      }
      return res;
    };
    prototype.include = function(){
      return this.intersectOn(this.permit.includes);
    };
    prototype.exclude = function(){
      return this.intersectOn(this.permit.excludes);
    };
    prototype.customExMatch = function(){
      var res;
      if (toString$.call(this.permit.exMatch).slice(8, -1) === 'Function') {
        res = this.permit.exMatch(this.accessRequest);
        if (res.constructor === AccessMatcher) {
          return res.result();
        }
        if (res === undefined) {
          return true;
        }
        if (toString$.call(res).slice(8, -1) !== 'Boolean') {
          throw Error(".match method of permit " + this.permit.name + " must return a Boolean value, was: " + toString$.call(res).slice(8, -1));
        }
        return res;
      } else {
        this.debug("permit.ex-match function not found for permit: " + this.permit);
        return false;
      }
    };
    prototype.customMatch = function(){
      var res;
      if (toString$.call(this.permit.match).slice(8, -1) === 'Function') {
        res = this.permit.match(this.accessRequest);
        this.debug('custom-match', this.permit.match, res);
        if (res.constructor === AccessMatcher) {
          return res.result();
        }
        if (res === undefined) {
          return true;
        }
        if (toString$.call(res).slice(8, -1) !== 'Boolean') {
          throw Error(".match method of permit " + this.permit.name + " must return a Boolean value, was: " + toString$.call(res).slice(8, -1));
        }
        return res;
      } else {
        this.debug("permit.match function not found for permit: " + this.permit);
        return false;
      }
    };
    prototype.intersectOn = function(partial){
      var res;
      if (partial == null) {
        return false;
      }
      if (toString$.call(partial).slice(8, -1) === 'Function') {
        partial = partial();
      }
      res = this.intersect.on(partial, this.accessRequest);
      return res;
    };
    prototype.validate = function(){
      if (!this.permit) {
        throw Error("PermitMatcher missing permit");
      }
      if (this.accessRequest != null && this.accessRequest === undefined) {
        throw Error("access-request is undefined");
      }
    };
    return PermitMatcher;
  }(Debugger));
  lo.extend(PermitMatcher, Debugger);
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);
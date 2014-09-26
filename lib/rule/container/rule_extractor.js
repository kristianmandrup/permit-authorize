// Generated by LiveScript 1.2.0
(function(){
  var util, array, unique, normalize, camelize, Debugger, RuleExtractor, toString$ = {}.toString;
  util = require('../../util');
  array = util.array;
  unique = array.unique;
  normalize = util.normalize;
  camelize = util.string.camelCase;
  Debugger = util.Debugger;
  module.exports = RuleExtractor = (function(){
    RuleExtractor.displayName = 'RuleExtractor';
    var prototype = RuleExtractor.prototype, constructor = RuleExtractor;
    importAll$(prototype, arguments[0]);
    function RuleExtractor(ruleContainer, action, subjects, debugging){
      this.ruleContainer = ruleContainer;
      this.action = action;
      this.subjects = subjects;
      this.debugging = debugging;
    }
    prototype.extract = function(){
      return this.registerActionSubjects(this.actionSubjects(), this.uniqueSubjects());
    };
    prototype.registerActionSubjects = function(actionContainer, subjects){
      this.debug("register action subjects", actionContainer, subjects);
      return unique(actionContainer.concat(subjects));
    };
    prototype.uniqueSubjects = function(){
      return unique(this.ruleSubjects());
    };
    prototype.actionSubjects = function(){
      var as;
      as = this.ruleContainer[this.action];
      this.debug('as', as);
      if (toString$.call(as).slice(8, -1) === 'Array') {
        return as;
      } else {
        return [];
      }
    };
    prototype.ruleSubjects = function(){
      return this._ruleSubjects || (this._ruleSubjects = this.__ruleSubjects());
    };
    prototype.__ruleSubjects = function(){
      var ruleSubjects;
      ruleSubjects = this.ruleContainer[this.action] || [];
      this.debug('rule-subjects', ruleSubjects);
      ruleSubjects = ruleSubjects.concat(this.normalizedSubjects());
      this.debug('rule-subjects', ruleSubjects);
      return ruleSubjects.map(function(subject){
        var val;
        val = camelize(subject);
        if (val === 'Any') {
          return '*';
        } else {
          return val;
        }
      });
    };
    prototype.normalizedSubjects = function(){
      return this._normalizedSubjects || (this._normalizedSubjects = normalize(this.subjects));
    };
    return RuleExtractor;
  }(Debugger));
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);
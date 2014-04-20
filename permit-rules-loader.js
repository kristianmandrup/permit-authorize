// Generated by LiveScript 1.2.0
(function(){
  var PermitRulesLoader, toString$ = {}.toString;
  PermitRulesLoader = (function(){
    PermitRulesLoader.displayName = 'PermitRulesLoader';
    var prototype = PermitRulesLoader.prototype, constructor = PermitRulesLoader;
    function PermitRulesLoader(filePath){
      this.filePath = filePath;
    }
    prototype.loadRulesFile = function(filePath){
      var fs;
      fs = require('fs');
      filePath || (filePath = this.filePath);
      if (filePath == null) {
        throw Error("Error: Missing filepath");
      }
      return fs.readFile(filePath, 'utf8', function(err, data){
        if (err) {
          throw Error("Error loading file: " + filePath + " - " + err);
        }
        this.loadedRules = JSON.parse(data);
        return processRules();
      });
    };
    prototype.loadRules = function(path){
      return this.loadRulesFile(path);
    };
    prototype.processRules = function(){
      var self;
      if (this.loadedRules == null) {
        throw Error("Rules not loaded");
      }
      this.processedRules = {};
      self = this;
      lo.each(this.loadedRules, function(key, rule){
        return rules[key] = self.ruleFor(rule);
      });
      return this.processedRules;
    };
    prototype.createRulesAt = function(permit, place){
      if (!toString$.call(permitis('Function')).slice(8, -1)) {
        throw Error("Not a permit, was: " + permit);
      }
      if (place != null) {
        if (!(permit.rules != null && toString$.call(permit.rules).slice(8, -1) === 'Object')) {
          throw Error("Permit has no rules object to place loaded rules at " + place);
        }
        return permit.rules[place] = this.processedRules;
      } else {
        return permit.rules = this.processedRules;
      }
    };
    prototype.ruleFor = function(rule){
      var key;
      key = lo.keys(rule)[0];
      if (!['can', 'cannot'].include(key)) {
        throw Error("Not a valid rule key, must be 'can' or 'cannot', was: " + key);
      }
      return this[key + "-factory"](rule[key]);
    };
    prototype.canFactory = function(action, subject){
      return function(){
        return this.ucan(action, subject);
      };
    };
    prototype.cannotFactory = function(action, subject){
      return function(){
        return this.ucannot(action, subject);
      };
    };
    return PermitRulesLoader;
  }());
}).call(this);

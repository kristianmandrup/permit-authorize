// Generated by LiveScript 1.2.0
(function(){
  var lo, Debugger, PermitRulesDbLoader;
  lo = require('../util/lodash_lite');
  Debugger = require('../debugger');
  PermitRulesDbLoader = (function(superclass){
    var prototype = extend$((import$(PermitRulesDbLoader, superclass).displayName = 'PermitRulesDbLoader', PermitRulesDbLoader), superclass).prototype, constructor = PermitRulesDbLoader;
    importAll$(prototype, arguments[1]);
    function PermitRulesDbLoader(filePath){
      this.filePath = filePath;
      PermitRulesDbLoader.superclass;
    }
    prototype.loadDb = function(options){
      this.options = options != null
        ? options
        : {};
      this.connectDb();
      this.loadData();
      this.loadedRules = JSON.parse(data);
      return this.processRules();
    };
    prototype.connectDb = function(){};
    prototype.loadData = function(){};
    return PermitRulesDbLoader;
  }(PermitRulesLoader, Debugger));
  module.exports = PermitRulesDbLoader;
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);
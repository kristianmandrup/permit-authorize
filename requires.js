// Generated by LiveScript 1.2.0
(function(){
  var lo, underscore, filePath, testPath, libPath, slice$ = [].slice;
  lo = require('lodash');
  underscore = function(str){
    return str.replace(/-/, '_');
  };
  filePath = function(){
    var paths;
    paths = slice$.call(arguments);
    return underscore(lo.flatten(['.', paths]).join('/'));
  };
  testPath = function(){
    var paths;
    paths = slice$.call(arguments);
    return filePath.apply(null, ['test'].concat(slice$.call(paths)));
  };
  libPath = function(){
    var paths;
    paths = slice$.call(arguments);
    return filePath.apply(null, ['lib'].concat(slice$.call(paths)));
  };
  module.exports = {
    util: function(path){
      return this.lib('util', path);
    },
    mw: function(path){
      return this.lib('mw', path);
    },
    rule: function(path){
      return this.lib('rule', path);
    },
    permit: function(path){
      return this.lib('permit', path);
    },
    accessRequest: function(path){
      return this.lib('access_request', path);
    },
    test: function(){
      var paths;
      paths = slice$.call(arguments);
      return require(testPath(paths));
    },
    fixture: function(path){
      return this.test('fixtures', path);
    },
    fix: function(path){
      return this.fixture(path);
    },
    factory: function(path){
      return this.test('factories', path);
    },
    fac: function(path){
      return this.factory(path);
    },
    file: function(){
      var paths;
      paths = slice$.call(arguments);
      return require(filePath(paths));
    },
    lib: function(){
      var paths;
      paths = slice$.call(arguments);
      return require(libPath(paths));
    },
    afile: function(path){
      return require(['.', path].join('/'));
    },
    m: function(path){
      return this.file(path);
    }
  };
}).call(this);

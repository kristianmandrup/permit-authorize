// Generated by LiveScript 1.2.0
(function(){
  var _, Book;
  _ = require('prelude-ls');
  module.exports = Book = (function(){
    Book.displayName = 'Book';
    var prototype = Book.prototype, constructor = Book;
    function Book(obj){
      var i$, ref$, len$, key;
      this.obj = obj;
      if (_.isType('Object', this.obj)) {
        for (i$ = 0, len$ = (ref$ = _.keys(this.obj)).length; i$ < len$; ++i$) {
          key = ref$[i$];
          this[key] = this.obj[key];
        }
      }
    }
    return Book;
  }());
}).call(this);

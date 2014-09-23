// Generated by LiveScript 1.2.0
(function(){
  var requires, expect, authorize, Ability, PermitRulesLoader, User, Book, user, book, ability, aBook, currentUser, cb;
  requires = require('../../requires');
  expect = require('expect.js');
  requires.test('test_setup');
  authorize = require('../../lib/index');
  Ability = authorize.ability.Ability;
  PermitRulesLoader = authorize.permit.rule.loader.RulesFileLoader;
  User = (function(){
    User.displayName = 'User';
    var prototype = User.prototype, constructor = User;
    function User(name){
      this.name = name;
    }
    return User;
  }());
  Book = (function(){
    Book.displayName = 'Book';
    var prototype = Book.prototype, constructor = Book;
    function Book(title){
      this.title = title;
    }
    return Book;
  }());
  user = function(name){
    return new User(name);
  };
  book = function(title){
    return new Book(title);
  };
  ability = function(user){
    return new Ability(user);
  };
  aBook = book('some book');
  currentUser = user('kris');
  cb = function(rules){
    return console.log(rules);
  };
  describe('index', function(){
    describe('Ability', function(){
      var myUser;
      beforeEach(function(){
        return myUser = user('mike');
      });
      return specify('is an Ability class', function(){
        return expect(ability(myUser).constructor).to.equal(Ability);
      });
    });
    return describe('PermitRulesLoader', function(){
      return specify('is class', function(){
        return expect(new PermitRulesLoader('xyz', cb).filePath).to.eql('xyz');
      });
    });
  });
}).call(this);

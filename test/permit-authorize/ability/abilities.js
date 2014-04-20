// Generated by LiveScript 1.2.0
(function(){
  var requires, Ability, createUser, ability;
  requires = require('../../../requires');
  Ability = requires.lib('ability');
  createUser = requires.fac('create-user');
  ability = function(user){
    return new Ability(user);
  };
  module.exports = {
    kris: ability(createUser.kris()),
    guest: ability(createUser.guest()),
    admin: ability(createUser.admin())
  };
}).call(this);

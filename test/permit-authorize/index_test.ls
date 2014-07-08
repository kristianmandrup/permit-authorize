requires  = require '../../requires'

expect = require 'expect.js'
requires.test 'test_setup'

authorize = require '../../index'

Ability = authorize.Ability
PermitRulesLoader  = authorize.RulesLoader

class User
  (@name) ->

class Book
  (@title) ->

user = (name) ->
  new User name

book = (title) ->
  new Book title

ability = (user) ->
  new Ability user

a-book = book 'some book'
current-user = user 'kris'

# if ability(current-user).allowed-for action: 'read', subject: a-book

describe 'index' ->
  describe 'Ability' ->
    var my-user
    before-each ->
      my-user := user 'mike'

    specify 'is an Ability class' ->
      expect(ability(my-user).constructor).to.equal Ability

  describe 'PermitRulesLoader' ->
    specify 'is class' ->
      expect(new PermitRulesLoader('xyz').file-path).to.eql 'xyz'
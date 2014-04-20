requires  = require '../../requires'

expect = require 'expect.js'
requires.test 'test_setup'

authorize = require '../../index'

Ability = authorize.Ability

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

describe 'Ability' ->
  specify 'is an Ability class' ->
    expect(ability!.constructor).to.equal Ability
lo = requires.util 'lodash-lite'

authorize = require 'permit-authorize'

Permit      = authorize.Permit
permit-for  = authorize.permit-for

class Book extends Base
  (obj) ->
    super ...

book = new Book title: title

class GuestUser extends User
  (obj) ->
    super ...

  role: 'guest'

guest-user = new GuestUser name: 'unknown'

guest-permit = permit-for('guest',
  match: (access) ->
    @matches(access).user role: 'guest'

  rules:
    ctx:
      area:
        guest: ->
          @ucan 'publish', 'Paper'
        admin: ->
          @ucannot 'publish', 'Paper'

    read: ->
      @ucan 'read' 'Book'
    write: ->
      @ucan 'write' 'Book'
    default: ->
      @ucan 'read' 'any'
)

Ability     = authorize.Ability

user = (name) ->
  new User name

book = (title) ->
  new Book title

ability = (user) ->
  new Ability user

a-book = book 'some book'
current-user = user 'kris'

current-ability = ability(current-user)

user-can = (access-request) ->
  current-ability.can access-request

user-cannot = (access-request) ->
  current-ability.cannot access-request

read-book = (user, book) ->
  # code for user to read the book

read-book(current-user, a-book) if user-can action: 'read', subject: a-book
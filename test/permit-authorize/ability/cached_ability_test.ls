requires  = require '../../../requires'

requires.test 'test_setup'

ability         = require './cached_abilities'
lo              = require 'lodash'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'
create-permit   = requires.fac 'create-permit'

Allower         = requires.lib 'allower'
CachedAbility   = requires.ability 'cached-ability'

Permit          = requires.lib 'permit'
permit-for      = requires.permit 'permit_for'
PermitMatcher   = requires.permit 'permit_matcher'

describe 'CachedAbility' ->
  var book

  create-book = (title) ->
    new Book title: title

  abilities   = {}
  requests    = {}
  users       = {}
  permits     = {}

  before ->
    book := create-book 'hello'

    # setup permits here !!
    permits.user := permit-for 'User',
      match: (access) ->
        @matching(access).user!
      rules: ->
        @ucan 'view', 'book'

    permits.guest := permit-for 'Guest',
      match: (access) ->
        @matching(access).role 'guest'
      rules: ->
        @ucan 'read', 'book'
        @ucannot 'write', 'book'

    permits.editor := permit-for 'Editor',
      match: (access) ->
        @matching(access).role 'editor'
      rules: ->
        @ucan ['read', 'write'], 'book'


    requests.user   = create-request.user-access!
    requests.empty  = create-request.empty!
    users.kris      = create-user.kris!

  describe 'create' ->
    context 'Ability for kris' ->
      specify 'is an Ability' ->
        ability.kris.constructor.should.eql CachedAbility

      describe 'user' ->
        specify 'has user kris' ->
          ability.kris.user.should.eql users.kris

  describe 'can' ->
    before ->

    context 'guest ability' ->
      specify 'read a book access should be allowed for guest user' ->
        ability.guest.can(action: 'read', subject: book).should.be.true

      specify 'write a book access should NOT be allowed for guest user' ->
        ability.guest.can(action: 'write', subject: book).should.be.false

    context 'admin ability' ->
      specify 'write a book access should NOT be allowed for admin user' ->
        ability.admin.can(action: 'write', subject: book).should.be.false

  describe 'cannot' ->
    before ->
      console.time 'guest ability: uncached'

    after ->
      console.time-end 'guest ability: uncached'

    context 'guest ability' ->
      specify 'read a book access should be allowed for admin user' ->
        ability.guest.cannot(action: 'read', subject: book).should.be.false

      specify 'write a book access should NOT be allowed for guest user' ->
        for i from 1 to 10
          ability.guest.cannot(action: 'write', subject: book).should.be.true

    context 'admin ability' ->
      specify 'write a book access should NOT be allowed for admin user' ->
        ability.admin.cannot('write', book).should.be.true

      specify 'write a book access should NOT be allowed for admin user' ->
        ability.admin.cannot(['write', book]).should.be.true

    context 'guest ability' ->
      before ->
        console.time 'guest ability: cached'

      after ->
        console.time-end 'guest ability: cached'

      specify 'read a book access should be allowed for admin user' ->
        ability.guest.cannot(action: 'read', subject: book).should.be.false

      specify 'write a book access should NOT be allowed for guest user' ->
        for i from 1 to 10
          ability.guest.cannot(action: 'write', subject: book).should.be.true


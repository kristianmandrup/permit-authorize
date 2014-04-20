requires  = require '../../requires'

requires.test 'test_setup'

ability         = require './ability/abilities'
lo              = require 'lodash'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'
create-permit   = requires.fac 'create-permit'

Allower         = requires.lib 'allower'
Ability         = requires.lib 'ability'

Permit          = requires.lib 'permit'
permit-for      = requires.permit 'permit_for'
PermitMatcher   = requires.permit 'permit_matcher'

describe 'Ability' ->
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
        ability.kris.constructor.should.eql Ability

      describe 'user' ->
        specify 'has user kris' ->
          ability.kris.user.should.eql users.kris

  describe 'allower' ->
    specify 'return Allower instance' ->
      ability.kris.allower(requests.empty).constructor.should.eql Allower

    specify 'Allower sets own access-request obj' ->
      ability.kris.allower(requests.user).access-request.should.eql requests.user

  describe 'allowed-for' ->
    before ->

    context 'guest ability' ->
      specify 'read a book access should be allowed for guest user' ->
        ability.guest.allowed-for(action: 'read', subject: book).should.be.true

      specify 'write a book access should NOT be allowed for guest user' ->
        ability.guest.allowed-for(action: 'write', subject: book).should.be.false

    context 'admin ability' ->
      specify 'write a book access should NOT be allowed for admin user' ->
        ability.admin.allowed-for(action: 'write', subject: book).should.be.false

  describe 'not-allowed-for' ->
    before ->
      # init local vars

    context 'guest ability' ->
      specify 'read a book access should be allowed for admin user' ->
        ability.guest.not-allowed-for(action: 'read', subject: book).should.be.false

      specify 'write a book access should NOT be allowed for guest user' ->
        ability.guest.not-allowed-for(action: 'write', subject: book).should.be.true

    context 'admin ability' ->
      specify 'write a book access should NOT be allowed for admin user' ->
        ability.admin.not-allowed-for(action: 'write', subject: book).should.be.true

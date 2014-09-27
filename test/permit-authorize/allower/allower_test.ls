requires  = require '../../../requires'

requires.test 'test_setup'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-user     = requires.fac 'create-user'
create-permit   = requires.fac 'create-permit'
create-request  = requires.fac 'create-request'

Allower         = requires.lib    'allower'   .Allower
Permit          = requires.lib    'permit'    .Permit
PermitRegistry  = requires.permit 'registry'  .PermitRegistry
permit-for      = requires.permit 'factory'   .permitFor

expect = require 'chai' .expect

describe 'Allower', ->
  var book

  allowers  = {}
  users     = {}
  requests  = {}
  permits   = {}

  book-access = (action, user) ->
    {user: user, action: action, subject: book}

  allower = (request) ->
    new Allower request

  before ->
    users.kris      := create-user.kris!
    users.guest     := create-user.guest!
    users.admin     := create-user.admin!
    users.editor    := create-user.role 'editor'

    book            := new Book title: 'to the moon and back'

  describe 'read-book-allower' ->
    before ->
      # init local vars
      requests.read-book    := book-access 'read', users.guest
      allowers.read-book    := new Allower requests.read-book

    specify 'return Allower instance' ->
      allowers.read-book.constructor.should.eql Allower

    specify 'Allower sets own access obj' ->
      allowers.read-book.access-request.should.eql requests.read-book
  
  describe 'allows and disallows' ->
    before ->
      Permit.registry.clean!

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

      # any user can view a book
      # a guest user can also read a book
      # an editor user can also read and write a book

      requests.read-book        := book-access 'read', users.guest
      requests.write-book       := book-access 'write', users.editor
      requests.not-write-book   := book-access 'write', users.guest

      allowers.read-book        := allower requests.read-book
      allowers.write-book       := allower requests.write-book
      allowers.not-write-book   := allower requests.not-write-book

      # permits.user.debug-on!
      # permits.guest.debug-on!
      # permits.editor.debug-on!

      allowers.read-book.debug-on!.timer-on!
      # allowers.write-book.debug-on!

      # Permit.registry.debug-on!

    describe 'allows!' ->
      before-each ->
        Permit.registry.clean-permits!

      specify 'read a book access should be allowed' ->
        expect allowers.read-book.allows! .to.be.true

      xspecify 'Editor write a book should be allowed' ->
        expect allowers.write-book.allows! .to.be.true

      xspecify 'Guest write a book should NOT be allowed' ->
        expect allowers.not-write-book.allows! .to.be.false

    xdescribe 'disallows!' ->
      before-each ->
        Permit.registry.clean-permits!

      specify 'Guest read a book access should NOT be disallowed' ->
        allowers.read-book.disallows!.should.be.false

      # since explit: @ucannot 'write', 'book' on gues-permit
      specify 'Editor write a book should NOT be disallowed' ->
        allowers.write-book.disallows!.should.be.false

requires  = require '../../requires'

requires.test 'test_setup'

lo              = requires.util 'lodash-lite'
User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'
create-permit   = requires.fac 'create-permit'

Authorizer      = requires.lib 'authorizer'

Ability         = requires.lib 'ability'

describe 'Authorizer' ->
  var ctx

  users         = {}
  requests      = {}
  permits       = {}
  authorizers   = {}
  books         = {}

  book = (title) ->
    new Book title: title

  authorizer = (user) ->
    new Authorizer user

  before ->
    books.hello       = book 'hello'
    users.guest       = create-user.guest!
    permits.guest     = create-permit.matching.role.guest! # check rules!

    ctx :=
      current-user: users.guest

    authorizers.basic = authorizer users.guest
    authorizers.basic.debug-on!

  describe 'create' ->
    specify 'should set user' ->
      authorizers.basic.user.should.eql users.guest

  describe 'run' ->
    xcontext 'read any book (collection name) request by guest user' ->
      before ->
        requests.read-book-collection =
          action:   'read'
          subject:  'book'

      specify.only 'user is authorized to read book collection' ->
        authorizers.basic.run(requests.read-book-collection).should.be.true

    context 'read actual book instance request by guest user' ->
      specify 'user is authorized to read book' ->
        authorizers.basic.run(action: 'read', subject: book!).should.be.true

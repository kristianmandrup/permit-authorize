requires = require '../../../requires'

requires.test 'test_setup'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'

access          = require './access'
ability         = require './abilities'

Ability       = requires.lib 'ability'

describe 'Ability' ->
  var abook

  book = (title) ->
    new Book title: title

  requests  = {}
  users     = {}
  res       = {}

  book-request = (action) ->
      user: {}
      action: action
      subject: abook

  before ->
    abook := book 'hello'
    requests.empty      = {}
    requests.guest      = create-request.role-access 'guest'
    requests.read-book  = book-request 'read'

  describe 'access-obj' ->
    context 'Ability for kris' ->
      before ->
        res.empty = ability.kris.access-obj(requests.empty)
        res.guest = ability.kris.access-obj(requests.guest)

      specify 'extends empty access with user thas has a name' ->
        res.empty.user.should.have.property 'name'

      specify 'extends empty access with user' ->
        res.empty.user.name.should.eql 'kris'

      specify 'extends access with user.role' ->
        res.guest.user.should.have.property 'role'

    context 'Guest ability' ->
      describe 'access-obj' ->
        context 'access-obj extended with read-book-access' ->
          before ->
            res.read-book = ability.guest.access-obj(requests.read-book)

          specify 'adds user.role: guest' ->
            res.read-book.user.role.should.eql 'guest'

          specify 'adds action: read' ->
            res.read-book.action.should.eql 'read'

          specify 'adds subject: book' ->
            res.read-book.subject.should.eql abook
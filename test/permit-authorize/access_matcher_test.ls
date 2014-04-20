requires  = require '../../requires'

requires.test 'test_setup'

Book          = requires.fix 'book'
matchers      = requires.lib 'matchers'

AccessMatcher = matchers.AccessMatcher

describe 'AccessMatcher' ->
  var book

  access-matchers = {}
  requests        = {}

  access-matcher = (request) ->
    new AccessMatcher request

  before ->
    book := new Book 'a book'
    requests.complex :=
      user:
        role: 'admin'
      action: 'read'
      subject: book

    requests.userless :=
      action: 'read'
      subject: book

    access-matchers.complex     := access-matcher requests.complex
    access-matchers.userless    := access-matcher requests.userless

  describe 'create' ->
    specify 'must have complex access request' ->
      access-matchers.complex.access-request.should.eql requests.complex

  describe 'chaining' ->
    before-each ->
      access-matchers.complex     := access-matcher requests.complex

    specify 'should match chaining: role(admin).action(read)' ->
      access-matchers.complex.role('admin').action('read').result!.should.be.true

    # has-xxxx methods have been deprecated
    xdescribe 'has-action calls result!' ->
      specify 'should match chaining: role(admin).action(read)' ->
        access-matchers.complex.role('admin').has-action('read').should.be.true

    xdescribe 'has-user calls result!' ->
      specify 'should match chaining: role(admin).action(read).hasUser()' ->
        access-matchers.complex.role('admin').action('read').has-user!.should.be.true

      specify 'should match chaining: role(admin).action(read).hasUser()' ->
        access-matchers.userless.role('admin').action('read').has-user!.should.be.false

    xdescribe 'has-subject calls result!' ->
      specify 'should match chaining: role(admin).action(read).user().hasSubject()' ->
        access-matchers.complex.role('admin').action('read').user!.has-subject!.should.be.true

  describe 'match-on' ->
    before-each ->
      access-matchers.complex     := access-matcher requests.complex

    specify 'should match action: read' ->
      access-matchers.complex.match-on(action: 'read').should.be.true

    specify 'should match role: admin' ->
      access-matchers.complex.match-on(role: 'admin').should.be.true

    specify 'should match role: admin and action: read' ->
      access-matchers.complex.match-on(role: 'admin', action: 'read').should.be.true

    specify 'should NOT match role: admin and action: write' ->
      access-matchers.complex.match-on(role: 'admin', action: 'write').should.be.false
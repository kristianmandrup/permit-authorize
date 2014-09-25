requires        = require '../../../../requires'

requires.test 'test_setup'

Book          = requires.fix 'book'
Matcher   = requires.lib 'access_request' .matcher.AccessMatcher

matcher = (req) ->
  new Matcher req

describe 'AccessMatcher' ->
  var book

  access-matchers = {}
  requests        = {}

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

    access-matchers.complex     := matcher requests.complex
    access-matchers.userless    := matcher requests.userless

  describe 'create' ->
    specify 'must have complex access request' ->
      access-matchers.complex.access-request.should.eql requests.complex

  describe 'chaining' ->
    before-each ->
      access-matchers.complex     := matcher requests.complex

    specify 'should match chaining: role(admin).action(read)' ->
      access-matchers.complex.role('admin').action('read').result!.should.be.true

  describe 'match-on' ->
    before-each ->
      access-matchers.complex     := matcher requests.complex

    specify 'should match action: read' ->
      access-matchers.complex.match-on(action: 'read').should.be.true

    specify 'should match role: admin' ->
      access-matchers.complex.match-on(role: 'admin').should.be.true

    specify 'should match role: admin and action: read' ->
      access-matchers.complex.match-on(role: 'admin', action: 'read').should.be.true

    specify 'should NOT match role: admin and action: write' ->
      access-matchers.complex.match-on(role: 'admin', action: 'write').should.be.false

  context 'using roles:' ->
    describe 'match' ->
      before-each ->
        access-matchers.complex     := matcher requests.complex

      specify 'should match admin role' ->
        access-matchers.complex.role('admin').result!.should.be.true

      specify 'should match admin role' ->
        access-matchers.complex.roles('admin', 'guest').result!.should.be.true

  context 'using actions:' ->
    describe 'match' ->
      before-each ->
        access-matchers.complex     := matcher requests.complex

      specify 'should match admin role' ->
        access-matchers.complex.action('read').result!.should.be.true

      specify 'should match admin role' ->
        access-matchers.complex.actions('read', 'write').result!.should.be.true

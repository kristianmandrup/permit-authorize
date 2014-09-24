requires        = require '../../../../requires'

requires.test 'test_setup'

Matcher         = requires.permit 'matcher'   .ExcludeMatcher
PermitRegistry  = requires.permit 'registry'  .PermitRegistry

setup           = requires.fix 'permits' .setup
Book            = requires.fix 'book'
User            = requires.fix 'user'

create-user     = requires.fac 'create-user'

describe 'IncludeMatcher' ->
  var matcher, book

  users     = {}
  permits   = {}
  requests  = {}

  matching = {}
  none-matching = {}

  before ->
    users.kris        := create-user.kris
    requests.user     :=
      user: users.kris

    permits.user      := setup.user-permit!
    matcher    := new PermitMatcher permits.user, requests.user

  describe 'include' ->
    describe 'includes user.name: kris' ->
      before ->
        permits.user.includes =
          user: users.kris

      specify 'matches access-request on includes intersect' ->
        matcher.include!.should.be.true

    describe 'includes empty {}' ->
      before ->
        permits.user.includes = {}

      specify 'matches access-request since empty includes always intersect' ->
        matcher.include!.should.be.true

    describe 'includes is nil' ->
      before ->
        permits.user.includes = void

      specify 'does NOT match access-request since NO includes intersect' ->
        matcher.include!.should.be.false

  describe 'custom-match' ->
    var subject
    var matcher, book

    users     = {}
    permits   = {}
    requests  = {}

    matching = {}
    none-matching = {}

    before ->
      book                := new Book title: 'far and away'
      requests.subject :=
        user: {}
        subject: book

      requests.ctx    :=
        ctx: void

      permits.book    := setup.book-permit!

      matching.matcher       := new PermitMatcher permits.book, requests.subject
      none-matching.matcher  := new PermitMatcher permits.book, requests.ctx

    context 'matching permit-matcher' ->
      before ->
        subject := matching.permit-matcher

      specify 'has permit' ->
        subject.permit.should.eql permits.book

      specify 'has subject access-request' ->
        subject.access-request.should.eql requests.subject

    context 'matching permit-matcher' ->
      before ->
        subject := none-matching.matcher

      specify 'has permit' ->
        subject.permit.should.eql permits.book

      specify 'has access-request' ->
        subject.access-request.should.eql requests.ctx

    specify 'matches access-request using permit.match' ->
      matching.permit-matcher.custom-match!.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.matcher.custom-match!.should.be.false

    describe 'invalid match method' ->
      before ->
        permits.user := setup.invalid-user!

      specify 'should throw error' ->
        ( -> none-matching.matcher.custom-match ).should.throw
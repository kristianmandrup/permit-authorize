requires        = require '../../../requires'

requires.test 'test_setup'
ability         = require '../ability/abilities'
matchers        = requires.lib 'access_request/matchers'
ContextMatcher  = matchers.ContextMatcher

describe 'ContextMatcher' ->
  var ctx-matcher
  var area-ctx

  requests = {}

  before ->
    area-ctx := {area: 'visitor' }
    requests.visitor :=
      ctx: area-ctx

  describe 'create' ->
    before-each ->
      ctx-matcher  := new ContextMatcher requests.visitor

    specify 'must have admin access request' ->
      ctx-matcher.access-request.should.eql requests.visitor

  describe 'match' ->
    before-each ->
      ctx-matcher  := new ContextMatcher requests.visitor

    specify 'should match area: visitor' ->
      ctx-matcher.match(area-ctx).should.be.true

    specify 'should NOT match area: member' ->
      ctx-matcher.match(area: 'member').should.be.false

    specify 'should match on no argument' ->
      ctx-matcher.match!.should.be.true

  describe 'match function' ->
    before-each ->
      requests.visitor :=
        ctx:
          auth: 'yes'

      ctx-matcher  := new ContextMatcher requests.visitor

    specify 'should match -> auth is yes' ->
      ctx-matcher.match( -> @auth is 'yes').should.be.true
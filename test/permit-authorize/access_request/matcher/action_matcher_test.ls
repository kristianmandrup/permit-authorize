requires        = require '../../../../requires'

requires.test 'test_setup'

Matcher   = requires.lib 'access_request' .matcher.ActionMatcher

matcher = (req) ->
  new Matcher req

describe 'ActionMatcher' ->
  var action-matcher

  requests = {}

  before ->
    requests.read :=
      action: 'read'

  describe 'create' ->
    before-each ->
      action-matcher  := matcher requests.read

    specify 'must have admin access request' ->
      action-matcher.access-request.should.eql requests.read

  describe 'match' ->
    before-each ->
      action-matcher  := matcher requests.read

    specify 'should match read action' ->
      action-matcher.match('read').should.be.true

    specify 'should NOT match write action' ->
      action-matcher.match('write').should.be.false

    specify 'should match on no argument' ->
      action-matcher.match!.should.be.true
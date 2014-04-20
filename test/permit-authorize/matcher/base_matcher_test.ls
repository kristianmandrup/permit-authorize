requires        = require '../../../requires'

requires.test 'test_setup'
ability       = require '../ability/abilities'
matchers      = requires.lib 'matchers'
BaseMatcher   = matchers.BaseMatcher

describe 'BaseMatcher' ->
  var matcher
  requests = {}

  before ->
    requests.empty := {}

  describe 'create' ->
    context 'no access request' ->
      before ->
        matcher  := new BaseMatcher

      specify 'must have access request' ->
        matcher.access-request.should.eql {}

    context 'empty access request' ->
      before ->
        matcher        := new BaseMatcher requests.empty

      specify 'must be a user matcher' ->
        matcher.should.be.an.instance-of BaseMatcher

      specify 'must have access request' ->
        matcher.access-request.should.eql requests.empty

      specify 'must have an intersect' ->
        matcher.intersect.should.have.property 'on'






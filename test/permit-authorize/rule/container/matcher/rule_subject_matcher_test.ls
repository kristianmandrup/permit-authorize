requires  = require '../../../../../requires'

requires.test 'test_setup'

Matcher = requires.rule 'container' .matcher.RuleSubjectMatcher

expect = require 'chai' .expect

describe 'RuleSubjectMatcher' ->
  var matcher

  create-matcher = (subjects, debug = true) ->
    new Matcher subjects

  describe 'create' ->
    describe 'invalid' ->
      specify 'throws' ->
        expect -> create-matcher void .to.throw

    describe 'valid' ->
      specify 'ok' ->
        expect -> create-matcher [] .to.not.throw

  context 'created' ->
    before ->
      matcher := create-matcher 'my matcher'


#  (@subjects) ->
#    unless typeof! @subjects is 'Array'
#      throw new Error "subject must be an Array, was: #{@subjects}"

  # match: (subject) ->

  # wildcards: ['*', 'any']
requires  = require '../../../../../requires'

requires.test 'test_setup'

Matcher = requires.rule 'container' .matcher.RuleSubjectMatcher

expect = require 'chai' .expect

subjects = {}

describe 'RuleSubjectMatcher' ->
  var matcher

  create-matcher = (subjects, debug = false) ->
    new Matcher subjects, debug

  describe 'create' ->
    describe 'invalid' ->
      specify 'throws' ->
        expect -> create-matcher void .to.throw

    describe 'valid' ->
      specify 'ok' ->
        expect -> create-matcher [] .to.not.throw

  context 'created' ->
    before-each ->
      matcher := create-matcher 'book'

    describe 'intersect-match' ->
      before-each ->
        matcher := create-matcher 'blip'

      specify 'should not match' ->
        expect(matcher.intersects 'blap').to.eql false

    describe 'match (subject)' ->
      context 'bad subject' ->
        before-each ->
          subjects.bad = 'bad book'

        specify 'should not match' ->
          expect(matcher.match subjects.bad).to.eql false

      context 'good subject' ->
        before-each ->
          subjects.good = 'book'

        specify 'should match' ->
          expect(matcher.match subjects.good).to.eql true

      context 'wildcard match' ->
        before-each ->
          matcher := create-matcher ['any']
          subjects.good = 'book'

        specify 'should match' ->
          expect(matcher.match subjects.good).to.eql true

#  (@subjects) ->
#    unless typeof! @subjects is 'Array'
#      throw new Error "subject must be an Array, was: #{@subjects}"

  # match: (subject) ->

  # wildcards: ['*', 'any']
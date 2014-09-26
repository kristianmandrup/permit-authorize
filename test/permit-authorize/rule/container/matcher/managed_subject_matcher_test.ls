requires  = require '../../../../../requires'

requires.test 'test_setup'

Matcher = requires.rule 'container' .matcher.ManagedSubjectMatcher

expect = require 'chai' .expect

describe 'ManagedSubjectMatcher' ->
  var matcher

  create-matcher = (subjects, debug = true) ->
    new Matcher subjects

  context 'create' ->
    before ->
      matcher := create-matcher 'my matcher'

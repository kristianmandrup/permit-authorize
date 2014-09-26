requires  = require '../../../../requires'

requires.test 'test_setup'

Matcher = requires.rule.container 'matcher' .RuleSubjectMatcher

expect = require 'chai' .expect

describe 'RepoCleaner' ->
  var matcher

  create-matcher = (subjects, debug = true) ->
    new Matcher subjects

  context 'basic repo' ->
    before ->
      matcher := create-matcher 'my repo'

requires  = require '../../../../requires'

requires.test 'test_setup'

RuleCleaner = requires.rule 'repo' .RuleCleaner

expect = require 'chai' .expect

describe 'RepoCleaner' ->
  var access-request, rule, repo
  var book
  var can, cannot

  create-repo = (name, debug) ->
    new RuleRepo name, debug

  context 'basic repo' ->
    before ->
      repo := create-repo 'my repo'

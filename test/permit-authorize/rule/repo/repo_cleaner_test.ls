requires  = require '../../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

RuleRepo    = requires.rule 'repo/rule_repo'
RepoCleaner = requires.rule 'repo' .RepoCleaner

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

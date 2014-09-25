requires  = require '../../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

RuleRepo        = requires.rule 'repo/rule_repo'
RepoRegistrator = requires.rule 'repo' .RepoRegistrator

expect = require 'chai' .expect

describe 'RepoRegistrator' ->
  var action, subjects, registrator
  var book

  create-repo = (name = 'my repo', debug = false) ->
    new RuleRepo name, debug

  create-regis = (repo, debug = true) ->
    repo ||= create-repo!
    new RepoRegistrator repo, debug

  context 'basic repo' ->
    before ->
      registrator := create-regis 'my repo'

      action    := 'edit'
      subjects  := ['book', 'article']

    describe 'add-rule (container, action, subjects)' ->
      specify 'adds the rule to container' ->
        registrator.add-rule container, action, subjects .should.eql true

    describe 'rule-extractor (rule-container, action, subjects)' ->
      # new RuleExtractor rule-container, action, subjects
      specify 'returns rule-extractor' ->
        registrator.rule-extractor(container, action, subjects).should.not.eql void

    # rule-container
    describe 'register-rule (act, actions, subjects)' ->

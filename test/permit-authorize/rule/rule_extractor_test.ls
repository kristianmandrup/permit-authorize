requires  = require '../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

RuleExtractor   = requires.lib 'rule' .RuleExtractor

expect = require 'chai' .expect

describe 'RepoRegistrator' ->
  var extractor

  create-extr = (container, action, subjects) ->
    new RepoExtractor container, action, subjects

  describe 'create' ->
    describe 'invalid' ->
      specify 'throws' ->
        expect( -> create-extr {}, 'ax').to.throw

    describe 'valid' ->

  context 'valid extractor' ->
    before ->
      extractor := create-extr {}, 'edit', 'Article'

  describe 'extract' ->
    # @register-action-subjects @action-subjects!, @unique-subjects!

  describe 'register-action-subjects (action-container, subjects)' ->
    # unique action-container.concat(subjects)

  describe 'unique-subjects' ->
    # unique @rule-subjects

  describe 'action-subjects' ->
#    as = @rule-container[action]
#    if typeof! as is 'Array' then as else []

  describe 'rule-subjects' ->
    # @_rule-subjects ||= @__rule-subjects!

  # TODO: refactor
  describe '__rule-subjects' ->

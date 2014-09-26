requires  = require '../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

RuleExtractor   = requires.lib 'rule' .RuleExtractor

expect = require 'chai' .expect

describe 'RepoRegistrator' ->
  var extractor

  create-extr = (container, action, subjects, debug = false) ->
    new RuleExtractor container, action, subjects, debug

  describe 'create' ->
    describe 'invalid' ->
      specify 'throws' ->
        expect( -> create-extr {}, 'ax').to.throw

    describe 'valid' ->

  context 'valid extractor' ->
    var actions, subjects
    before-each ->
      extractor := create-extr {}, 'edit', 'Article'
      actions   := ['user', 'book']
      subjects  := ['user', 'article']


    describe 'extract' ->
      # @register-action-subjects @action-subjects!, @unique-subjects!
      xspecify 'extracts rule?' ->
        expect extractor.extract .to.eql {}

    describe 'register-action-subjects (action-container, subjects)' ->
      before ->

      # unique action-container.concat(subjects)
      specify 'adds unique subjects to action container' ->
        expect extractor.register-action-subjects(actions, subjects) .to.eql [ 'book', 'user', 'article' ]

    describe 'unique-subjects' ->
      # unique @rule-subjects
      xspecify 'adds unique subjects to action container' ->
        expect extractor.unique-subjects(subjects.concat(['user'])) .to.eql subjects


    describe 'action-subjects' ->
  #    as = @rule-container[action]
  #    if typeof! as is 'Array' then as else []

      context 'no rules for action' ->
        before-each ->
          extractor := create-extr {}, 'edit', 'Article'

        specify 'finds no subjects for action' ->
          expect extractor.action-subjects! .to.eql []

      context 'has subjects for action' ->
        var ext
        before-each ->
          ext := create-extr {edit: ['Book']}, 'edit', 'Article'

        specify 'gets subjects for action' ->
          expect ext.action-subjects! .to.eql ['Book']

    describe 'rule-subjects' ->
      # @_rule-subjects ||= @__rule-subjects!
      specify 'extracts rule subject' ->
        expect extractor.rule-subjects! .to.eql ['Article']

    describe '__rule-subjects' ->
      specify 'extracts rule subject' ->
        expect extractor.__rule-subjects! .to.eql ['Article']

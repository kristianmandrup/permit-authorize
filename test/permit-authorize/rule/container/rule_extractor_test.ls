requires  = require '../../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

Extractor   = requires.rule 'container' .RuleExtractor

expect = require 'chai' .expect

describe 'RuleExtractor' ->
  var extractor
  var actions, subjects

  create-extr = (container, action, subjects, debug = false) ->
    new Extractor container, action, subjects, debug

  actions   := ['user', 'book']
  subjects  := ['user', 'article']


  describe 'create' ->
    describe 'invalid' ->
      specify 'throws' ->
        expect( -> create-extr {}, 'ax').to.throw

    describe 'valid' ->

  context 'valid extractor' ->
    before-each ->
      extractor := create-extr {}, 'edit', ['Article', 'book']

    describe 'extract' ->
      specify 'extracts rule?' ->
        expect extractor.extract! .to.eql ['Article', 'Book']

    describe.only 'unique-subjects' ->
      before-each ->
        duplicates = subjects.concat(['user'])
        extractor := create-extr {}, 'edit', duplicates

      specify 'returns unique normalized subjects' ->
        expect extractor.unique-subjects! .to.eql ['Article', 'User']

    describe 'action-subjects' ->
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


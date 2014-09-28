requires  = require '../../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

Adder       = requires.rule 'container' .RuleAdder

expect = require 'chai' .expect

create-adder = (container, action, subjects, debug = true) ->
  new Adder container, action, subjects, debug

describe 'RuleAdder' ->
  var act, action, actions, subjects, adder, container, book, res

  context 'basic repo' ->
    before ->
      container   := {}

      act       := 'can'
      action    := 'edit'
      actions   := ['edit', 'publish']
      subjects  := ['book', 'article']

      adder     := create-adder container, action, subjects

    describe 'add(container, action, subjects)' ->
      specify 'adds the rule to container' ->
        expect adder.add container, action, subjects .to.equal adder

    describe 'extractor (rule-container, action, subjects)' ->
      # new RuleExtractor rule-container, action, subjects
      specify 'returns rule-extractor with extract function' ->
        expect adder.extractor(container, action, subjects).extract .to.be.an.instanceOf Function

    describe 'manage-actions' ->
      specify 'globals' ->
        expect adder.manage-actions .to.eql ['create', 'delete', 'update', 'edit']

    context 'not a manage rule' ->
      before ->
        res := adder.add-manage!

      describe 'add-manage' ->
        specify 'returns void' ->
          expect res .to.eql void

      # action is read
      describe 'action-subjects' ->
        specify 'them' ->
          expect adder.action-subjects! .to.eql ['Book', 'Article']


    context 'a manage rule' ->
      before ->
        adder     := create-adder container, 'manage', ['book', 'movie']
        res       := adder.add-manage!
        # console.log adder.container

      describe 'add-manage' ->
        specify 'not void' ->
          expect res .to.eql adder

        specify 'adds for all manage actions' ->
          for action in adder.manage-actions
            expect adder.container[action] .to.eql ['Book', 'Movie']



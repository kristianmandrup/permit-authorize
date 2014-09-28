requires  = require '../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

Adder       = requires.lib 'rule' .RuleAdder

expect = require 'chai' .expect

create-adder = (container, action, subjects, debug = true) ->
  new Adder debug

describe 'RuleAdder' ->
  var act, action, actions, subjects, adder, container, book

  context 'basic repo' ->
    before ->
      container   := {}

      act       := 'can'
      action    := 'edit'
      actions   := ['edit', 'publish']
      subjects  := ['book', 'article']

      adder     := create-adder container, action, subjects

    describe 'add (container, action, subjects)' ->
      specify 'adds the rule to container' ->
        expect adder.add! .to.equal adder

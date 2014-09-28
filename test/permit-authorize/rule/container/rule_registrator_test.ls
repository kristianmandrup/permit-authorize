requires  = require '../../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

Registrator = requires.lib 'rule' .RuleRegistrator

expect = require 'chai' .expect

create-regis = (debug = true) ->
  new Registrator {}, debug

describe 'RuleRegistrator' ->
  var act, action, actions, subjects, registrator, container
  var book

  context 'basic repo' ->
    before ->
      container   := {}
      registrator := create-regis!

      act       := 'can'
      action    := 'edit'
      actions   := ['edit', 'publish']
      subjects  := ['book', 'article']


    # rule-container
    describe 'register-rule (act, actions, subjects)' ->
      specify 'registers a rule' ->
        res = registrator.register act, actions, subjects
        expect res .to.equal registrator

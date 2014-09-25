requires        = require '../../../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

ActRuleProcessor = requires.permit 'rule' .loader.processor.ActRuleProcessor

processor = (act, rule) ->
  new ActRuleProcessor act, rule

describe 'ActRuleProcessor' ->
  var pr, act, rule

  before ->
    act   := 'can'
    rule  :=
      read: 'Article'

  describe 'create' ->
    context 'invalid' ->
      specify 'throws' ->
        expect(-> processor act, void).to.throw

    context 'valid' ->
      before ->
        pr := processor(act, rule)

      specify 'ok' ->


      #  (@act, @rule) ->
      #    rules = []
      specify 'rules list set empty' ->
        pr.rules.should.be.empty

      #  process: ->
      #    for action, subject of @rule
      #      fun = @resolve(@act, action, subject)
      #      rules.push fun
      #    ->
      #      for rule in rules
      #        @rule!
      describe 'process' ->
        var res

        before ->
          res := pr.process!

        # TODO: test in rule ExecutionContext
        specify 'should return function' ->
          res.should.be.an.instanceOf Function

      #  resolve: (act, action, subject) ->
      #    ->
      #      @["u#{act}"] action, subject
      describe 'resolve(act, action, subject)' ->
        var res

        # TODO: test in rule ExecutionContext
        context 'can read article' ->
          before ->
            res := pr.resolve 'can', 'read', 'article'

          specify 'returns ucan function' ->
            res.should.be.an.instanceOf Function

        # TODO: test in rule ExecutionContext
        context 'cannot edit book' ->
          before ->
            res := pr.resolve 'cannot', 'edit', 'book'

          specify 'returns ucannot function' ->
            res.should.be.an.instanceOf Function
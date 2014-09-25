requires        = require '../../../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

RulesProcessor = requires.permit 'rule' .loader.processor.RulesProcessor

processor = (key, rule, debug = true) ->
  new RulesProcessor key, rule, debug

describe 'ActRuleProcessor' ->
  var pr, key, rule

  before ->
    key   := 'editor'
    rule  :=
      can:
        read: 'Article'

  describe 'create' ->
    context 'invalid' ->
      specify 'throws' ->
        expect(-> processor key, void).to.throw

    context 'valid' ->
      before ->
        pr := processor(key, rule)

      specify 'ok' ->


      #  (@rule-key, @rule, @debugging) ->
      #    @processed-rules = {}
      specify 'rules list set empty' ->
        pr.processed-rules.should.eql {}

      #  process: ->
      #    @debug "processRule", @rule-key, @rule
      #    @processed-rules[@rule-key] = @processed-rule
      describe 'process' ->
        var res

        before ->
          res := pr.process!
          console.log 'res', res

        specify 'yeah' ->
          res.should.eql {}

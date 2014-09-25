requires        = require '../../../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

RuleProcessor = requires.permit 'rule' .loader.processor.RuleProcessor

processor = (key, rule, debug = true) ->
  new RuleProcessor key, rule, debug

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

      #  processed-rule: ->
      #    @debug "processed-rule"
      #    act-key = Object.keys(rule).0
      #    unless ['can', 'cannot'].contains act-key
      #      throw Error "Not a valid rule key, must be 'can' or 'cannot', was: #{key}"
      #    @process-act-rule act-key, rule[act-key]
      describe 'processed-rule' ->


      #  process-act-rule: (act, act-rule)->
      #    new ActRuleProcessor(act, act-rule).process!
      describe 'processed-act-rule' ->
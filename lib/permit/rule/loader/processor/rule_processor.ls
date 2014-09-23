ActRuleProcessor = require './act_rule_processor'

module.exports = class RuleProcessor
  (@rule-key, @rule) ->

  process: ->
    @debug "processRule", @rule-key, @rule
    @processed-rules[@rule-key] = @processed-rule

  processed-rule: ->
    @debug "processed-rule"
    act-key = Object.keys(rule).0
    unless ['can', 'cannot'].contains(act-key)
      throw Error "Not a valid rule key, must be 'can' or 'cannot', was: #{key}"
    @process-act-rule act-key, rule[act-key]

  process-act-rule: ->
    new ActRuleProcessor(act, act-rule).process!


ActRuleProcessor = require './act_rule_processor'
Debugger         = require '../../../../util' .Debugger

contains         = require '../../../../util' .array.contains

#    editor:
#      can:
#        listen-to: 'music'
#      cannot:
#        read: 'poetry'

module.exports = class RuleProcessor implements Debugger
  (@rule-key, @rule, @debugging) ->
    @processed-rules = {}

  process: ->
    @debug "processRule", @rule-key, @rule
    @processed-rules[@rule-key] = @process-acts!
    @processed-rules

  # can and cannot
  #    can:
  #      listen-to: 'music'
  #    cannot:
  #      read: 'poetry'
  process-acts: ->
    [process-act 'can', process-act 'cannot'].filter (item) ->
      item !== void

  process-act: (key) ->
    _validate-act key
    @process-act-rule act-key, @rule[key]

  process-act-rule: (act, act-rule)->
    new ActRuleProcessor(act, act-rule).process!

  _validate-act: (key) ->
    unless contains ['can', 'cannot'], key
      throw Error "Not a valid rule key, must be 'can' or 'cannot', was: #{key}"

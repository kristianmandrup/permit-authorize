RuleProcessor = require './rule_processor'

#  user:
#    editor:
#      can:
#        listen-to: 'music'
#    admin:
#      cannot:
#        read: 'poetry'
module.exports = class RulesProcessor
  (@obj) ->
    unless @obj['rules']
      throw new Error("Rules are missing a 'rules' root key");
    @rules = @obj['rules']
    process!

  process: ->
    @debug "process", @rules
    for key of @rules
      @validate key
      @processed-rules[key] = process-rule @rules[key]

    @processed-rules

  validate: (key) ->
    unless valid(key)
      throw new Error("Invalid rule identifier #{key}, must be one of #{valid-keys}")

  valid-keys: ['user', 'action', 'subject', 'ctx']

  valid: (key) ->
    if find valid-keys, key then true else false

  rule-clazz: RuleProcessor

  process-rule: (rule) ->
    new @rule-clazz(rule).process!




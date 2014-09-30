util                = require '../../../util'
Debugger            = util.Debugger
KeyRuleApplier      = require './key_rule_applier'
ObjectRuleApplier   = require './object_rule_applier'

module.exports = class RuleApplier implements Debugger
  (@thing, @ctx, @debugging) ->

  _type: 'RuleApplier'

  apply: ->
    @applier!.apply

  applier: ->
    @key-rule-applier! or @object-rule-applier!

  key-rule-applier: ->
    new KeyRuleApplier @thing, @ctx if typeof @thing is 'String'

  object-rule-applier: ->
    new ObjectRuleApplier @thing, @ctx if typeof @thing is 'Object'

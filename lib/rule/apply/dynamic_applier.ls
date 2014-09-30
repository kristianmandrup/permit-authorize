RulesApplier  = require './rules_applier'
util          = require '../util'

module.exports = class DynamicApplier extends RulesApplier
  (@execution-context, @rules, @access-request, @debugging) ->
    @validate-rules!
    super ...
    @debug 'apply dynamic rules', @rules
    @

  _type: 'DynamicApplier'

  valid-request: ->
    return false unless typeof! @access-request is 'Object'
    Object.keys(@access-request).length > 0

  validate-rules: ->
    unless util.valid-rules @rules
      throw Error "No rules defined for permit: #{@name}"

  apply: ->
    @debug 'apply'
    return false unless @valid-request!
    @execute-rules! or @apply-rules!

  execute-rules: ->
    @rules @access-request if typeof! @rules is 'Function'

  apply-rules: ->
    return @ unless @valid-request!
    @debug 'apply access rules on', @access-request
    for name in ['action', 'user', 'ctx']
      @apply-dynamic @ar-value(name)
    @

  ar-value: (property) ->
    @access-request[property]

  # for more advances cases, also pass context 'action' as 2nd param
  apply-dynamic: (rule)->
    @debug 'apply-dynamic', rule
    @rule-applier rule, ctx .apply! if rule
    @

  rule-applier: (rule, ctx) ->
    new RuleApplier rule, ctx

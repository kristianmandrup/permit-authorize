# Used to apply a set of rules (can and cannot rules)
# typically this is via a rules: key on a permit
# The permit can be setup to either apply all rules, (iterating through the rules object)
# or just apply a subset depending on the context (fx the action of the incoming access-request)

Debugger    = require '../util' .Debugger
util        = require './util'

# To apply a rule, means to execute the .can or .cannot statement in order to add one or more entries
# to the corresponding can-rules or cannot-rules object in the rule-rep
module.exports = class RulesAccessor implements Debugger
  #
  (@permit, @access-request, @debugging) ->
    @rules      = @permit.rules
    @rule-repo  = @permit.rule-repo
    unless typeof! @repo is 'Object'
      throw Error "RuleApplier must be passed a RuleRepo, was: #{@repo}"

    unless util.valid-rules @rules
      throw Error "RuleApplier must be passed the rules to be applied, was: #{@rules}"

    unless @access-request is undefined or typeof! @access-request is 'Object'
      throw Error "AccessRequest must be an Object, was: #{@access-request}"
    @debugging = @debugging

  context-rules: (context)->
    if typeof! context is 'Object'
      return context

    return @rules unless typeof! context is 'String'
    if typeof! @rules[context] is 'Object'
      @rules[context]
    else
      @debug "no such rules context: #{context}", @rules
      @rules

  valid-request: ->
    return false if not @access-request
    if Object.keys(@access-request).length > 0 then true else false

  # so as not to be same name as can method used "from the outside, ie. via Ability"
  # for the functions within rules object, they are executed with the rule applier as this (@) - ie. the context
  # and thus have @ucan and @ucannot available within that context!
  # for the @apply-action-rules, we could return a function, where the current action is also in the context,
  # and is the default action for all @ucan and @ucannot calls!!
  ucan: (actions, subjects, ctx) ->
    @repo.register-rule 'can', actions, subjects, ctx

  ucannot: (actions, subjects, ctx) ->
    @repo.register-rule 'cannot', actions, subjects, ctx


/*
  action: ->
    @access-request?.action

  user: ->
    @access-request?.user

  subject: ->
    @access-request?.subject

  ctx: ->
    @access-request?.ctx
*/

delegate = (obj, name, source) ->
  obj[name] = ->
    @[source][name] if @source

for name in ['action', 'user', 'subject', 'ctx']
  delegate RulesAccessor, 'accessRequest', name

/*
  can-rules: ->
    @repo.can-rules

  cannot-rules: ->
    @repo.cannot-rules
*/

for name in ['canRules', 'cannotRules']
  delegate RulesAccessor, 'repo', name

RulesAccessor <<< Debugger
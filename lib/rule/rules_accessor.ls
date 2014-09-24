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

# action: ->
#   accessRequest?.action

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
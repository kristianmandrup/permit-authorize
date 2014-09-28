util        = require '../../util'
array       = util.array
#contains   = array.contains
#object     = util.object
#unique     = array.unique
normalize   = util.normalize
# camelize  = util.string.camel-case

Debugger        = util.Debugger
RuleMixin       = require './rule_mixin'
RuleAdder

module.exports = class RuleRegistrator implements RuleMixin, Debugger
  (@container, @act, @actions, @subjects, @debugging) ->
    @_validate!
    @actions = normalize @actions
    @

  _validate: ->
    unless typeof! @container is 'Object'
      throw Error "Container must be an object, was: #{@container}"

  # rule-container
  register: ->
    # TODO: perhaps use new AccessRequest(act, actions, subjects).normalize
    @container = @container-for act # can-rules or cannot-rules
    @debug 'rule container', @container
    @add-actions!
    @

  add-actions: ->
    # should add all subjects to rule in one go I think, then use array test on subject
    # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
    for action in @actions
      @add action

  add: (action) ->
    new RuleAdder @container, action, @subjects, @debugging

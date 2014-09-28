util        = require '../../util'
array       = util.array
normalize   = util.normalize

Debugger        = util.Debugger
RuleMixin       = require './rule_mixin'
RuleAdder       = require './rule_adder'

module.exports = class RuleRegistrator implements RuleMixin, Debugger
  (@container, @debugging = true) ->
    @_validate!
    @

  _type: 'RuleRegistrator'

  _validate: ->
    unless typeof! @container is 'Object'
      throw Error "Container must be an object, was: #{@container}"

  # rule-container
  register: (@act, @actions, @subjects) ->
    @debug 'register', @act, @actions, @subjects


    @act-container = @container-for act # can-rules or cannot-rules
    @actions  = normalize @actions
    @subjects = normalize @subjects

    console.log 'add em', @act, @actions, @subjects

    @add-actions!
    @

  add-actions: ->
    @debug 'add actions', @actions
    # should add all subjects to rule in one go I think, then use array test on subject
    # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
    for action in @actions
      @add action

  add: (action) ->
    @adder!.add action

  adder: ->
    new RuleAdder @act-container, @subjects, @debugging

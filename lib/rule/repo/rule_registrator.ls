util      = require '../../util'

#array     = util.array
#contains  = array.contains
#unique    = array.unique
#object    = util.object

Debugger        = util.Debugger
RuleExtractor   = require '../rule_extractor'

module.exports = class RuleRegistrator implements Debugger
  (@repo) ->

  add-rule: (rule-container, action, subjects) ->
    @debug 'add rule', action, subjects
    throw Error("Container must be an object") unless typeof! rule-container is 'Object'

    # TODO: refactor - extract method
    registered-action-subjects = @rule-extractor(rule-container, action, subjects).extract!
    rule-container[action] = registered-action-subjects

    # TODO: extract method
    if action is 'manage'
      for action in @manage-actions
        rule-container[action] = registered-action-subjects
    # console.log 'action subjects', rule-container[action]

  rule-extractor: (rule-container, action, subjects) ->
    new RuleExtractor rule-container, action, subjects

  # rule-container
  register-rule: (act, actions, subjects) ->
    # TODO: perhaps use new AccessRequest(act, actions, subjects).normalize
    actions = normalize actions

    rule-container = @container-for act # can-rules or cannot-rules
    @debug 'rule container', rule-container

    # TODO: extract method
    # should add all subjects to rule in one go I think, then use array test on subject
    # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
    for action in actions
      @add-rule rule-container, action, subjects

  # TODO: duplicate!
  manage-actions: ['create', 'edit', 'delete']
util      = require '../../util'

#array     = util.array
#contains  = array.contains
#unique    = array.unique
#object    = util.object

Debugger  = util.Debugger

module.exports = class RuleRegistrator implements Debugger
  (@repo) ->

  # TODO: refactor - extract method
  add-rule: (rule-container, action, subjects) ->
    @debug 'add rule', action, subjects

    throw Error("Container must be an object") unless typeof! rule-container is 'Object'
    rule-subjects = rule-container[action] || []

    subjects = normalize subjects
    rule-subjects = rule-subjects.concat subjects

    rule-subjects = rule-subjects.map (subject) ->
      val = camel-case subject
      if val is 'Any' then '*' else val

    unique-subjects = unique rule-subjects

    action-subjects = rule-container[action]

    unless typeof! action-subjects is 'Array'
      action-subjects = []

    registered-action-subjects = @register-action-subjects action-subjects, unique-subjects

    rule-container[action] = registered-action-subjects

    if action is 'manage'
      for action in @manage-actions!
        rule-container[action] = registered-action-subjects

    # console.log 'action subjects', rule-container[action]

  register-action-subjects: (action-container, subjects) ->
    @debug "register action subjects", action-container, subjects
    unique action-container.concat(subjects)

  # rule-container
  register-rule: (act, actions, subjects) ->
    # TODO: perhaps use new AccessRequest(act, actions, subjects).normalize
    actions = normalize actions

    rule-container = @container-for act # can-rules or cannot-rules
    @debug 'rule container', rule-container
    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @add-rule rule-container, action, subjects
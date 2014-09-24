# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!
util      = require '../../util'
array     = util.array
contains  = array.contains
unique    = array.unique

object    = util.object

Debugger  = util.Debugger

camel-case  = util.string.camel-case
normalize   = util.normalize

module.exports = class RuleRepo implements Debugger
  (@name, @debugging) ->

  can-rules: {}
  cannot-rules: {}

  display: ->
    console.log "name:", @name
    console.log "can-rules:", @can-rules
    console.log "cannot-rules:", @cannot-rules

  clean-all: ->
    @clean 'can'
    @clean 'cannot'
    @

  # allow clean only can or cannot rules
  # if no argument, clean both
  clean: (act)->
    return @clean-all! if act is undefined
    unless act is 'can' or act is 'cannot'
      throw Error "Repo can only clear 'can' or 'cannot' rules, was: #{act}"

    @debug 'clean', act
    @["#{act}Rules"] = {}
    @

  clear-all: ->
    @clean-all!

  clear: (act)->
    @clean act

  subject-clazz: (subject)->
    if typeof! subject is 'Object'
      subject-clazz = subject.constructor.display-name
    else
      subject-clazz = subject

  wildcards: ['*', 'any']

  find-matching-subject: (subjects, subject) ->
    # first try wild-card 'any' or '*'
    return true if contains @wildcards, subject

    if typeof! subject is 'Array'
      self = @
      return contains subjects, subject

    unless typeof! subject is 'String'
      throw Error "find-matching-subject: Subject must be a String to be matched, was #{subject}"

    camelized = camel-case subject
    subjects.index-of(camelized) != -1

  # TODO: simplify, extract methods and one or more classes!!!
  match-rule: (act, access-request) ->
    @debug 'match-rule', act, access-request

    act = camel-case act
    @debug 'act', act
    action = access-request.action
    subject = access-request.subject
    @debug 'action', action
    @debug 'subject', subject

    subj-clazz = @subject-clazz subject
    rule-container = @container-for act
    @debug 'rule-container', rule-container

    @match-manage-rule(rule-container, subj-clazz) if action is 'manage'

    @debug 'subj-clazz', subj-clazz
    return false unless subj-clazz

    action-subjects = rule-container[action]
    @debug 'action-subjects', action-subjects
    return false unless action-subjects

    @match-subject-clazz action-subjects, subj-clazz

  match-subject-clazz: (action-subjects, subj-clazz) ->
    @debug 'match-subject-clazz', action-subjects, subj-clazz
    return false unless typeof! action-subjects is 'Array'
    @find-matching-subject action-subjects, subj-clazz

  match-manage-rule: (rule-container, subj-clazz) ->
    manage-subjects = rule-container['manage']

    found = match-subject-clazz manage-subjects, subj-clazz

    return found if found

    # see if we are allowed to create, edit and delete for this subject class!
    manage-action-subjects(rule-container).all (action-subjects) ->
      match-subject-clazz action-subjects, subj-clazz

  manage-action-subjects: (rule-container) ->
    arr.map @manage-actions!, (action) ->
      rule-container[action]

  manage-actions: ->
    ['create', 'edit', 'delete']

  # for now, lets forget about ctx
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

  container-for: (act) ->
    act = act.to-lower-case!
    c = @["#{act}Rules"]
    throw Error "No valid rule container for: #{act}" unless typeof! c is 'Object'
    c

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

RuleRepo <<< Debugger

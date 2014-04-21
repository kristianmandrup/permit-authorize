# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

requires    = require '../../requires'
lo          = require 'lodash'
camel-case  = requires.util 'string-util' .camel-case
normalize   = requires.util 'normalize'
Debugger    = requires.lib 'debugger'


module.exports = class RuleRepo implements Debugger
  (@name) ->

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
    return true if lo.find @wildcards, (wildcard) ->
      subjects.index-of(wildcard) != -1

    if typeof! subject is 'Array'
      self = @
      return lo.find subject, (subj) ->
        self.find-matching-subject subjects, subj

    unless typeof! subject is 'String'
      throw Error "find-matching-subject: Subject must be a String to be matched, was #{subject}"

    camelized = camel-case subject
    subjects.index-of(camelized) != -1

  # TODO: simplify, extract methods and one or more classes!!!
  match-rule: (act, access-request) ->
    @debug 'match-rule', act, access-request

    act = camel-case act
    action = access-request.action
    subject = access-request.subject

    subj-clazz = @subject-clazz subject
    rule-container = @container-for act

    @match-manage-rule(rule-container, subj-clazz) if action is 'manage'

    @debug 'subj-clazz', subj-clazz
    return unless subj-clazz
    action-subjects = rule-container[action]
    return unless action-subjects
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
    lo.map @manage-actions!, (action) ->
      rule-container[action]

  manage-actions: ->
    ['create', 'edit', 'delete']

  # for now, lets forget about ctx
  add-rule: (rule-container, action, subjects) ->
    throw Error("Container must be an object") unless typeof! rule-container is 'Object'
    rule-subjects = rule-container[action] || []

    subjects = normalize subjects
    rule-subjects = rule-subjects.concat subjects

    rule-subjects = lo.map rule-subjects, (subject) ->
      val = camel-case subject
      if val is 'Any' then '*' else val

    unique-subjects = lo.unique rule-subjects

    action-subjects = rule-container[action]

    unless typeof! action-subjects is 'Array'
      action-subjects = []

    rule-container[action] = @register-action-subjects action-subjects, unique-subjects

    if action is 'manage'
      self = @
      lo.each @manage-actions!, (action) ->
        rule-container[action] = self.register-action-subjects action-subjects, unique-subjects

    # console.log 'action subjects', rule-container[action]

  register-action-subjects: (action-container, subjects) ->
    # console.log "action-container", action-container, subjects
    lo.unique action-container.concat(subjects)

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

    for action in actions
      # should add all subjects to rule in one go I think, then use array test on subject
      # http://preludels.com/#find to see if subject that we try to act on is in this rule subject array
      @add-rule rule-container, action, subjects

lo.extend RuleRepo, Debugger

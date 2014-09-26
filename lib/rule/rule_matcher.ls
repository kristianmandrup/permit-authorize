util      = require '../util'

#array     = util.array
#contains  = array.contains
#unique    = array.unique
#object    = util.object
every     = util.array.every

Debugger  = util.Debugger

module.exports = class RuleMatcher implements Debugger
  (@act, @access-request) ->
    @act = camel-case @act

  # TODO: refactor into smaller functions, avoid local vars!
  # TODO: extract-method ;)
  match: ->
    @debug 'match-rule', @act, @access-request
    action = @access-request.action
    subject = @access-request.subject

    @debug 'action, subject', action, subject

    subj-clazz = @subject-clazz subject

    @debug 'rule-container', @rule-container!

    @match-manage-rule(@rule-container!, subj-clazz) if action is 'manage'

    @debug 'subj-clazz', subj-clazz
    return false unless subj-clazz

    action-subjects = @rule-container![action]
    @debug 'action-subjects', action-subjects
    return false unless action-subjects

    @match-subject-clazz action-subjects, subj-clazz

  container-for: (act) ->
    act = act.to-lower-case!
    c = @["#{act}Rules"]
    throw Error "No valid rule container for: #{act}" unless typeof! c is 'Object'
    c

  rule-container: ->
    @_container ||= @container-for @act

  match-subject-clazz: (action-subjects, subj-clazz) ->
    @debug 'match-subject-clazz', action-subjects, subj-clazz
    return false unless typeof! action-subjects is 'Array'
    @find-matching-subject action-subjects, subj-clazz

  wildcards: ['*', 'any']

  subject-clazz: (subject)->
    if typeof! subject is 'Object'
      subject-clazz = subject.constructor.display-name
    else
      subject-clazz = subject

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

  match-manage-rule: (rule-container, subj-clazz) ->
    manage-subjects = rule-container['manage']

    found = match-subject-clazz manage-subjects, subj-clazz

    return found if found

    # see if we are allowed to create, edit and delete for this subject class!
    every manage-action-subjects(rule-container), (action-subjects) ->
      match-subject-clazz action-subjects, subj-clazz

  manage-action-subjects: (rule-container) ->
    @manage-actions.map (action) ->
      rule-container[action]

  manage-actions: ['create', 'edit', 'delete']
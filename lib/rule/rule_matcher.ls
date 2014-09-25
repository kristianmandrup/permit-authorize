every = require '../util' .array.every

module.exports = class RuleMatcher
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

  rule-container: ->
    @_container ||= @container-for @act

  match-subject-clazz: (action-subjects, subj-clazz) ->
    @debug 'match-subject-clazz', action-subjects, subj-clazz
    return false unless typeof! action-subjects is 'Array'
    @find-matching-subject action-subjects, subj-clazz

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
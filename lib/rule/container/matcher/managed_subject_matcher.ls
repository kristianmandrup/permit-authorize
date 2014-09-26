util      = require '../../../util'
Debugger  = util.Debugger

ManagedSubjectMatcher = require './managed_subject_matcher'

module.exports = class RuleActionMatcher implements Debugger
  (@container) ->

  match: (subject) ->
    @is-managed subject

  is-managed: (subject) ->
    found = @match-subject @manage-subjects!, subject
    return found if found

    # see if we are allowed to create, edit and delete for this subject class!
    for subjects in @managed-subjects!
      return false unless @match-subject subjects, subj-clazz
    true

  managed-subjects: ->
    @_manage-subjects ||= @container['manage']

  match-subject: (subjects, subject) ->
    @subject-matcher subjects, subject .match subject

  subject-matcher: (subjects, subject)->
    new ManagedSubjectMatcher subjects

  manage-action-subjects: ->
    @manage-actions.map (action) ->
      @container[action]

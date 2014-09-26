# utily      = require 'util'
util      = require '../../../util'
flatten   = util.array.flatten
Debugger  = util.Debugger

ManagedSubjectMatcher = require './managed_subject_matcher'
SubjectMatcher        = require './rule_subject_matcher'
RuleMixin             = require '../rule_mixin'

module.exports = class RuleActionMatcher implements Debugger, RuleMixin
  (@container, @debugging) ->
    @debug '@container', @container

  match: (subject) ->
    return false unless subject
    @is-managed subject

  is-managed: (subject) ->
    # see if there is a 'manage' key that contains the subject
    return true if @match-subject subject
    @matches-all-manage-actions subject

  matches-all-manage-actions: (subject) ->
    # see if we are allowed to create, edit and delete for this subject class!
    for subjects in @manage-action-subjects!
      return false unless @match-subject subject, subjects || []
    true

  managed-subjects: ->
    @_managed-subjects ||= @container['manage'] || []

  match-subject: (subject, subjects) ->
    @subject-matcher(subjects).match subject

  subject-matcher: (subjects)->
    subjects ||= @managed-subjects!
    new SubjectMatcher subjects

  manage-action-subjects: ->
    # manage-actions: create, edit, delete
    self = @
    @manage-actions.map (action) ->
      self.container[action]

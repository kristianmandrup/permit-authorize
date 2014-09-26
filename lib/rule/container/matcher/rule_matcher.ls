utily       = require 'util'
util        = require '../../../util'

#array      = util.array
#contains   = array.contains
#unique     = array.unique
#object     = util.object
every       = util.array.every
camelize    = util.string.camel-case
clazz-for   = util.string.clazz-for

Debugger    = util.Debugger
RuleMixin   = require '../rule_mixin'

ManagedSubjectMatcher =  require './managed_subject_matcher'
RuleSubjectMatcher    =  require './rule_subject_matcher'


module.exports = class RuleMatcher implements Debugger, RuleMixin
  (@container, @act, @access-request, @debugging) ->
    @_validate!
    @_configure!
    @

  _configure: ->
    @act      = @act.to-lower-case!
    @action   = @access-request.action
    @subject  = @access-request.subject
    @clazz    = clazz-for @subject
    @debug 'container', @container
    @debug 'action, subject, clazz', @action, @subject, @clazz


  _validate: ->
    @_validate-act! and @_validate-container!

  _validate-container: ->
    unless typeof! @act-container! is 'Object'
      throw Error "No container for #{@act} in container: #{utily.inspect @container}"

  _validate-act: ->
    unless @act is 'can' or @act is 'cannot'
      throw Error "act must be a String: 'can' or 'cannot', was: #{utily.inspect @act}"

  match: ->
    @debug 'match'
    return false unless @clazz
    return @managed-subject-match! if @action is 'manage'

    @debug 'action-subjects', @action-subjects!
    return false unless @action-subjects!
    @match-subject!

  managed-subject-match: ->
    @managed-subject-matcher!.match @clazz

  managed-subject-matcher: ->
    new ManagedSubjectMatcher @act-container!, @debugging

  match-subject: ->
    return false unless @action-subjects!
    @subject-matcher!.match @clazz

  subject-matcher: ->
    return void unless @action-subjects!
    new RuleSubjectMatcher @action-subjects!, @debugging

  action-subjects: ->
    @_action-subjects ||= @act-container![@action]

  act-container: ->
    @_container ||= @container-for @act


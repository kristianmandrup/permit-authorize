util        = require '../../util'

#array      = util.array
#contains   = array.contains
#unique     = array.unique
#object     = util.object
every       = util.array.every

Debugger    = util.Debugger
RuleMixin   = './rule_mixin'

module.exports = class RuleMatcher implements Debugger, RuleMixin
  (@rule-container, @act, @access-request) ->
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


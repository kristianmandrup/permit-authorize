util            = require '../../util'
Debugger        = util.Debugger
RuleExtractor   = require './rule_extractor'

module.exports = class RuleAdder implements Debugger
  (@container, @action, @subjects) ->

  add:  ->
    @debug 'add rule', @action, @subjects
    @action-subjects @action, @subjects
    @container[@action] = @action-subjects!
    @add-manage!
    @

  action-subjects: ->
    @_action-subjects ||= @rule-extractor(@container, @action, @subjects).extract!

  add-manage: ->
    return unless @action is 'manage'
    for action in @manage-actions
      @container[action] = @action-subjects!
    # console.log 'action subjects', rule-container[action]
    @

  rule-extractor:  ->
    new RuleExtractor @container, @action, @subjects

  manage-actions: require '../../util' .globals.manage-actions
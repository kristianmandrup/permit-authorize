util            = require '../../util'
Debugger        = util.Debugger
RuleExtractor   = require './rule_extractor'

module.exports = class RuleAdder implements Debugger
  (@container, @subjects, @debugging) ->
    @_validate!

  _type: 'RuleAdder'

  _validate: ->
    unless typeof! @container is 'Object'
      throw Error "Container must be an Object, was: #{@container}"

    unless typeof! @subjects is 'Array'
      throw Error "subjects must be an Array, was: #{@subjects}"

  add: (action) ->
    unless typeof! action is 'String'
      throw Error "action must be a String, was: #{action}"

    @debug 'add rule', action, @subjects
    @action-subjects action, @subjects
    @container[action] = @action-subjects!
    @add-manage action
    @

  action-subjects: (action) ->
    @_action-subjects ||= @extractor(action).extract!

  add-manage: (action) ->
    return unless action is 'manage'
    @debug 'add-manage', action
    for action in @manage-actions
      @container[action] = @action-subjects!
    @

  extractor: (action) ->
    new RuleExtractor @container, action, @subjects

  manage-actions: require('../../util').globals.manage-actions
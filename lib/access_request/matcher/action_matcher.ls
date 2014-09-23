Debugger  = require '../../util' .Debugger
BaseMatcher = require './base_matcher'

module.exports = class ActionMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-action!

  set-action: ->
    @action ||= if @access-request? then @access-request.action else ''

  match: (action) ->
    if typeof! action is 'Function'
      return action.call @action

    return true if @death-match 'action', action
    @action is action

ActionMatcher <<< Debugger

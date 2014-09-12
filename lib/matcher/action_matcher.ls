requires        = require '../../requires'
lo              = requires.util 'lodash-lite'

Debugger        = requires.lib 'debugger'
BaseMatcher     = requires.matcher 'base'

class ActionMatcher extends BaseMatcher
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

lo.extend ActionMatcher, Debugger

module.exports = ActionMatcher
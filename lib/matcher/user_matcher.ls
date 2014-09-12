requires        = require '../../requires'
lo              = requires.util 'lodash-lite'
Debugger        = requires.lib 'debugger'
BaseMatcher     = requires.matcher 'base'

class UserMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-user!

  set-user: ->
    @user ||= if @access-request? then @access-request.user else {}

  match: (user) ->
    if typeof! user is 'Function'
      return user.call @user

    return true if @death-match 'user', user
    @intersect.on user, @user

lo.extend UserMatcher, Debugger

module.exports = UserMatcher
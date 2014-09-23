Debugger  = require '../../util' .Debugger
BaseMatcher = require './base_matcher'

module.exports = class UserMatcher extends BaseMatcher
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

UserMatcher <<< Debugger



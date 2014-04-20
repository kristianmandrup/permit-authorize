requires  = require '../requires'
Intersect = requires.util 'intersect'
lo  = require 'lodash'

Debugger = requires.lib 'debugger'

class BaseMatcher implements Debugger
  (access-request) ->
    @set-access-request access-request
    @set-intersect!

  match: (value) ->
    false

  death-match: (name, value) ->
    return true if @[name] and value is void
    false

  set-access-request: (access-request) ->
    @access-request = if access-request then access-request else {}

  set-intersect: ->
    @intersect ||= Intersect()

lo.extend BaseMatcher, Debugger

class ActionMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-action!

  set-action: ->
    @action ||= if @access-request? then @access-request.action else ''

  match: (action) ->
    if _.is-type 'Function' action
      return action.call @action

    return true if @death-match 'action', action
    @action is action

lo.extend ActionMatcher, Debugger

class UserMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-user!

  set-user: ->
    @user ||= if @access-request? then @access-request.user else {}

  match: (user) ->
    if _.is-type 'Function' user
      return user.call @user

    return true if @death-match 'user', user
    @intersect.on user, @user

lo.extend UserMatcher, Debugger

class SubjectMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-subject!

  set-subject: ->
    @subject ||= if @access-request? then @access-request.subject else {}

  match: (subject) ->
    if _.is-type 'Function' subject
      return subject.call @subject
    return true if @death-match 'subject', subject
    @intersect.on subject, @subject

  match-clazz: (subject) ->
    clazz = subject.camelize!
    return false unless @subject and @subject.constructor
    @subject.constructor.display-name is clazz

lo.extend SubjectMatcher, Debugger

class ContextMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-ctx!

  set-ctx: ->
    @ctx ||= if @access-request? then @access-request.ctx else {}

  match: (ctx) ->
    if _.is-type 'Function' ctx
      return ctx.call @ctx

    return true if @death-match 'ctx', ctx
    @intersect.on ctx, @ctx

lo.extend ContextMatcher, Debugger

class AccessMatcher
  (@access-request) ->
    @match-result = true

  user-matcher: ->
    @um ||= new UserMatcher(@access-request)

  subject-matcher: ->
    @sm ||= new SubjectMatcher(@access-request)

  action-matcher: ->
    @am ||= new ActionMatcher(@access-request)

  context-matcher: ->
    @cm ||= new ContextMatcher(@access-request)

  match-on: (hash) ->
    all = hash
    for key in _.keys hash
      match-fun   = @[key]
      match-value = hash[key]

      if _.is-type 'Function' match-fun
        delete all[key]
        match-fun.call(@, match-value).match-on(all)
    @result!

  result: ->
    @match-result

  update: (result) ->
    @match-result = @match-result and result

  user: (user) ->
    @update @user-matcher!.match(user)
    @

  role: (role) ->
    @user role: role
    @

  subject: (subject) ->
    @update @subject-matcher!.match(subject)
    @

  subject-clazz: (clazz) ->
    @update @subject-matcher!.match-clazz(clazz)
    @

  action: (action) ->
    @update @action-matcher!.match(action)
    @

  context: (ctx) ->
    @update @context-matcher!.match(ctx)
    @

  ctx: (ctx) ->
    @context ctx

lo.extend AccessMatcher, Debugger

module.exports =
  BaseMatcher     : BaseMatcher
  UserMatcher     : UserMatcher
  ActionMatcher   : ActionMatcher
  SubjectMatcher  : SubjectMatcher
  ContextMatcher  : ContextMatcher
  AccessMatcher   : AccessMatcher
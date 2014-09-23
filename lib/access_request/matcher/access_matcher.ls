Debugger  = require '../../util' .Debugger

UserMatcher     = require './user_matcher'
ActionMatcher   = require './action_matcher'
SubjectMatcher  = require './subject_matcher'
ContextMatcher  = require './context_matcher'

module.exports = class AccessMatcher implements Debugger
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
    for key of hash
      match-fun   = @[key]
      match-value = hash[key]

      if typeof! match-fun is 'Function'
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

  roles: (roles) ->
    for role in roles
      @role(role) unless @match-result
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

  actions: (actions) ->
    for action in actions
      @action(action) unless @match-result
    @

  context: (ctx) ->
    @update @context-matcher!.match(ctx)
    @

  ctx: (ctx) ->
    @context ctx

AccessMatcher <<< Debugger

requires        = require '../../requires'
lo              = requires.util 'lodash-lite'

Debugger        = requires.lib 'debugger'
UserMatcher     = requires.matcher 'user'
ActionMatcher   = requires.matcher 'action'
SubjectMatcher  = requires.matcher 'subject'
ContextMatcher  = requires.matcher 'context'

class AccessMatcher implements Debugger
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

lo.extend AccessMatcher, Debugger

module.exports = AccessMatcher
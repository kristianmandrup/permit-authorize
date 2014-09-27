Debugger      = require '../util' .Debugger
AccessRequest = require '../access_request' .AccessRequest
Ability       = require '../ability' .Ability

module.exports = class Authorizer implements Debugger
  (@user) ->

  # tests if user can perform given action on object in the current context
  # a simple wrapper for can, which can either take either
  # - an object {action: 'edit', ...}
  # or individual arguments:
  #   action, subject, ...
  # and normalize them before calling can
  # TODO: I think we already normalize in the Ability
  authorize: (action, subject, ctx) ->
    @debug 'authorize', action, subject, ctx
    if typeof! action is 'Object'
      [action, subject, ctx]  = [obj.action, obj.subject, obj.context or obj.ctx]
    @can action, subject, context

  # default!
  ability-clazz: Ability

  create-ability: ->
    new @ability-clazz @user, @debugging

  ability: ->
    @current-ability ||= @create-ability!

  access: (action, subject, ctx) ->
    ar = new AccessRequest @user, action, subject, ctx, @debugging
    ar.debug-on! if @debugging
    ar

  can: (action, subject, context) ->
    @debug 'can', action, subject, context
    @ability!.can @access(action, subject, context)

  cannot: (action, subject, context) ->
    @debug 'cannot', action, subject, context
    @ability!.cannot @access(action, subject, context)

Authorizer <<< Debugger
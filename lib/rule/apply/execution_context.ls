Debugger = require '../../util' .Debugger

# a context to execute a rule
module.exports = class ExecutionContext implements Debugger
  (@repo, @debugging) ->
    @debug 'execute context', @repo
    @_validate!
    @

  _validate: ->
    unless typeof! @repo is 'Object'
      throw Error "ExecutionContext must take an Object, was: #{@repo}"

    # so as not to be same name as can method used "from the outside, ie. via Ability"
    # for the functions within rules object, they are executed with the rule applier as this (@) - ie. the context
    # and thus have @ucan and @ucannot available within that context!
    # for the @apply-action-rules, we could return a function, where the current action is also in the context,
    # and is the default action for all @ucan and @ucannot calls!!
  ucan: (actions, subjects, ctx) ->
    @debug 'ucan', actions, subjects, ctx
    @repo.register 'can', actions, subjects, ctx

  ucannot: (actions, subjects, ctx) ->
    @debug 'ucannot', actions, subjects, ctx
    @repo.register 'cannot', actions, subjects, ctx

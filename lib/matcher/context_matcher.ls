lo          = require '../util/lodash_lite'
Debugger    = require '../debugger'

BaseMatcher = require './base_matcher'

class ContextMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-ctx!

  set-ctx: ->
    @ctx ||= if @access-request? then @access-request.ctx else {}

  match: (ctx) ->
    if typeof! ctx is 'Function'
      return ctx.call @ctx

    return true if @death-match 'ctx', ctx
    @intersect.on ctx, @ctx

lo.extend ContextMatcher, Debugger

module.exports = ContextMatcher
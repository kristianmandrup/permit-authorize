Debugger    = require '../../util' .Debugger
Intersect   =  require '../../util' .Intersect

module.exports = class ContextMatcher implements Debugger
  (@context) ->
    unless @context.name
      throw new Error "Match context (permit) missing a name: #{@context}"
    @intersect ||= Intersect()

  match: ->
    false

  intersect-on: (partial) ->
    return false unless partial?

    if typeof! partial is 'Function'
      partial = partial!

    @intersect.on @context, partial

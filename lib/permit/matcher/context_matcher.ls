Debugger    = require '../../util' .Debugger
Intersect   =  require '../../util' .Intersect

module.exports = class ContextMatcher implements Debugger
  (@context, @key, @debugging) ->
    @debug 'set match-context', @context, 'KEY', @key
    unless @context.name
      throw new Error "Match context (permit) missing a name: #{@context}"

    @match-context = @context[@key]

  match: ->
    false

  intersect-on: (partial) ->
    @debug 'intersectOn', partial
    return false unless partial?

    if typeof! partial is 'Function'
      partial = partial!

    @intersect ||= Intersect()
    @debug 'perform intersect.on', @match-context, partial
    @intersect.on @match-context, partial

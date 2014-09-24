Debugger = require '../../util' .Debugger

module.exports = class ContextMatcher implements Debugger
  (@context) ->
    unless @context.name
      throw new Error "Match context (permit) missing a name: #{@context}"

  match: ->
    false

  intersect-on: (partial) ->
    return false unless partial?

    if typeof! partial is 'Function'
      partial = partial!
    res = @intersect.on partial, @access-request
    res

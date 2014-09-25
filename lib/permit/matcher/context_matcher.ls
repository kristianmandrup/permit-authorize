Debugger          = require '../../util' .Debugger
Intersect         = require '../../util' .Intersect
MatchingContext   = require './matching_contex'

module.exports = class ContextMatcher implements Debugger
  (@context, @key, @access-request, @debugging) ->
    @validate!

  validate: ->
    unless typeof! @context is 'Object'
      throw new Error "Context must be an Object, was: #{@context}"
    unless typeof! @key is 'String'
      throw new Error "Key must be a String, was: #{@key}"

  matching-context: ->
    new MatchingContext @context, @access-request

  match: ->
    @debug 'match', @match-context
    @intersect! or @fun! or @none!

  none: ->
    false

#  intersect:
#    includes:
#      user:
#        role: 'admin'
#
#    excludes:
#      user:
#        name: 'My evil twin'
  intersect: ->
    return false unless @context.intersect
    @intersect-context = @context.intersect[@key]

    return false unless typeof! @intersect-context is 'Object'

    @debug 'intersect', @intersect-context, @access-request
    @intersect-on @access-request

#  fun:
#      includes: ->
#          @matching!.actions ['read', 'write']
  fun: ->
    return false unless @context.fun
    @match-fun = @context.fun[@key]

    return false unless typeof! @match-fun is 'Function'

    @debug 'fun', @match-fun, @access-request
    res = @match-fun.call @matching-context!

    if res.constructor is AccessMatcher
      return res.result!

    return false if res is undefined

    unless typeof! res is 'Boolean'
      throw Error "#{@key} method of context #{@context.fun} must return a Boolean value, was: #{typeof! res}"

    return res

  intersect-on: (partial) ->
    @debug 'intersectOn', partial
    return false unless partial?

    if typeof! partial is 'Function'
      partial = partial!

    @intersect ||= Intersect()
    @debug 'perform intersect.on', @intersect-context, partial
    @intersect.on @intersect-context, partial

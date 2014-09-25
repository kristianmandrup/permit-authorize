Debugger          = require '../../util' .Debugger

module.exports = class ContextMatcher implements Debugger
  (@context, @key, @access-request, @debugging) ->
    console.log 'ContextMatcher', @
    @validate!
    @context = @context.matches if @context.matches
    @

  validate: ->
    unless typeof! @context is 'Object'
      throw new Error "context must be an Object, was: #{@context}"
    unless typeof! @key is 'String'
      throw new Error "Key must be a String, was: #{@key}"

    # TODO: in module
    unless typeof! @access-request is 'Object'
      throw new Error "access-request must be an Object, was: #{@access-request}"

  matching-context: ->
    new (require './matching_context') @context, @access-request

  match: ->
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

    @intersect-on @access-request

#  fun:
#      includes: ->
#          @matching!.actions ['read', 'write']
  fun: ->
    @debug 'fun context', @context
    return false unless @context.fun
    @match-fun = @context.fun[@key] || @context.fun

    @debug 'match fun', @match-fun
    return false unless typeof! @match-fun is 'Function'

    @debug 'fun', @match-fun, @access-request
    res = @match-fun.call @matching-context!

    if typeof! res.result is 'Function'
      return res.result!

    return false if res is undefined

    unless typeof! res is 'Boolean'
      throw Error "#{@key} method of context #{@context.fun} must return a Boolean value, was: #{typeof! res}"

    return res

  intersect-context: ->
    @_intersect-context ||= @context.intersect[@key] || @context.intersect

  intersect-on: (partial) ->
    partial ||= @access-request

    @debug 'intersect.on', @intersect-context!, partial
    return false unless typeof! @intersect-context! is 'Object'
    return false unless typeof! partial is 'Object'

    if typeof! partial is 'Function'
      partial = partial!

    @debug 'intersect partial:', partial

    @intersector!.on @intersect-context!, partial

  intersector: ->
    @_intersector ||= require '../../util' .Intersect()

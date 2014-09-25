AccessMatcher   = require '../../access_request' .matcher.AccessMatcher
ContextMatcher  = require './context_matcher'

module.exports = class IncludeMatcher extends ContextMatcher
  (context, @access-request, @debugging) ->
    super context, @@default-key, @debugging

  @default-key = 'includes'

  match: ->
    console.log @
    @debug 'match', @match-context
    @include! or @in-match!

  include: ->
    return false unless typeof! @match-context is 'Object'
    @debug 'intersect', @match-context, @access-request
    @intersect-on @access-request

  in-match: ->
    return false unless typeof! @match-context is 'Function'

    res = @match-context @access-request
    @debug 'custom-match', @permit.match, res

    if res.constructor is AccessMatcher
      return res.result!

    return false if res is undefined

    unless typeof! res is 'Boolean'
      throw Error "#{@key} method of context #{@context.name} must return a Boolean value, was: #{typeof! res}"

    return res
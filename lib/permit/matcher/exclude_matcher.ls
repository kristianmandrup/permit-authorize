AccessMatcher   = require '../../access_request' .matcher.AccessMatcher
ContextMatcher  = require './context_matcher'

module.exports = class ExcludeMatcher extends ContextMatcher
  (context, @access-request, @debugging) ->
    super context, @@default-key, @debugging

  @default-key = 'excludes'

  match: ->
    @exclude! or @match!

  exclude: ->
    @intersect-on @access-request

  ex-match: ->
    return false unless typeof! @match-context is 'Function'
    res = @match-context @access-request

    if res.constructor is AccessMatcher
      return res.result!

    return false if res is undefined

    unless typeof! res is 'Boolean'
      throw Error ".match method of permit #{@context.name} must return a Boolean value, was: #{typeof! res}"

    return res

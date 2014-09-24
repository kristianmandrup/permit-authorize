AccessMatcher   = require '../../access_request' .matcher.AccessMatcher
ContextMatcher  = require './context_matcher'

module.exports = class IncludeMatcher extends ContextMatcher
  (context, @access-request, @debugging) ->
    super context

  match: ->
    @exclude! or @custom-ex-match!

  exclude: ->
    @intersect-on @context.excludes

  match: ->
    if typeof! @context.ex-match is 'Function'
      res = @context.ex-match @access-request
      if res.constructor is AccessMatcher
        return res.result!

      return true if res is undefined

      unless typeof! res is 'Boolean'
        throw Error ".match method of permit #{@context.name} must return a Boolean value, was: #{typeof! res}"

      return res
    else
      @debug "permit.ex-match function not found for permit: #{@context.name}"
      false
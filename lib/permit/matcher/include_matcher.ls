AccessMatcher   = require '../../access_request' .matcher.AccessMatcher
ContextMatcher  = require './context_matcher'

module.exports = class IncludeMatcher extends ContextMatcher
  match: ->
    @include! or @custom-match!

  include: ->
    @intersect-on @context.includes

  custom-match: ->
    if typeof! @context.match is 'Function'
      res = @context.match @access-request
      @debug 'custom-match', @permit.match, res

      if res.constructor is AccessMatcher
        return res.result!

      return true if res is undefined

      unless typeof! res is 'Boolean'
        throw Error ".match method of permit #{@context.name} must return a Boolean value, was: #{typeof! res}"

      return res
    else
      @debug "permit.match function not found for permit: #{@context.name}"
      false
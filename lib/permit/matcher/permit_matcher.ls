# The matcher is used to determine if the Permit should apply at all in the given access context
# Given an access-request, it should check the permit via:
#   permit.match
#   permit.ex-match

# It should also check the permit.includes and permit.excludes
# which may contain objects used to test intersection on the access-request
# if any of all these gives a positive match, the permit should be used for the access-request
# otherwise the permit will be ignored

# To enable debugging, simply do:
#   PermitMatcher.debug-on!

Debugger        = require '../../util' .Debugger
ContextMatcher  = require('./context_matcher')
CompiledMatcher = require('./compiled_matcher')

# Tries to match access request on available permit matchers
# to determine if permit should be used for this access check or not
module.exports = class PermitMatcher implements Debugger
  (@context, @access-request, @debugging) ->
    @validate!
    @

  matchers: {}

  match: (options = {})->
    @debug 'match', options
    # includes and excludes can contain a partial (object) used to do intersection test on access-request
    @include! or @match-compiled! and not @exclude!

  match-compiled: ->
    @_mc ||= new CompiledMatcher(@context, @access-request, @debugging).match!

  include: ->
    @_include ||= @matcher('include').match!

  exclude: ->
    @_exclude ||= @matcher('exclude').match!

  matcher: (key) ->
    @matchers[key] ||= new ContextMatcher @context, key, @access-request, @debugging

  # TODO: refactor everywhere to more elegant system!
  validate: ->
    unless typeof! @context is 'Object'
      throw Error "context must be an Object, was: #{@context}"
    unless typeof! @access-request is 'Object'
      throw Error "access request must be an Object, was: #{@access-request}"


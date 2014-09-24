Intersect     = require '../../util' .Intersect
AccessMatcher = require '../../access_request' .matcher.AccessMatcher

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

Debugger = require '../../util' .Debugger

# Tries to match access request on available permit matchers
# to determine if permit should be used for this access check or not
module.exports = class PermitMatcher implements Debugger
  (@context, @access-request, @debugging) ->
    @validate!
    @intersect = Intersect()

  match: (options = {})->
    @debug 'permit-matcher match'
    # includes and excludes can contain a partial (object) used to do intersection test on access-request
    res = @include! and not @exclude!
    return res if options.compiled is false
    @debug 'compiled result:', @match-compiled!
    mc = @match-compiled!
    @debug 'match compiled', mc
    res or mc

  include: ->
    @include-matcher!.match!

  exclude: ->
    @include-matcher!.match!

  include-matcher: ->
    @_include-matcher ||= new IncludeMatcher @context, @access-request, @debugging

  exclude-matcher: ->
    @_exclude-matcher ||= new ExcludeMatcher @context, @access-request, @debugging

  validate: ->
    # use object intersection test if permit has includes or excludes
    throw Error "PermitMatcher missing permit" unless @context
    if @access-request? and @access-request is undefined
      throw Error "access-request is undefined"

PermitMatcher <<< Debugger

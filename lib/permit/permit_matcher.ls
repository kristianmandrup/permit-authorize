requires  = require '../../requires'
lo        = requires.util 'lodash-lite'

Intersect     = requires.util 'intersect'
AccessMatcher = requires.lib('matchers').AccessMatcher

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

Debugger = requires.lib 'debugger'

module.exports = class PermitMatcher implements Debugger
  (@permit, @access-request, @debugging) ->
    @intersect = Intersect()
    @validate!

  match: ->
    # includes and excludes can contain a partial (object) used to do intersection test on access-request
    (@include! or @custom-match!) and not (@exclude! or @custom-ex-match!)

  include: ->
    @intersect-on @permit.includes

  exclude: ->
    @intersect-on @permit.excludes

  custom-ex-match: ->
    if typeof! @permit.ex-match is 'Function'
      res = @permit.ex-match @access-request
      if res.constructor is AccessMatcher
        return res.result!

      return true if res is undefined

      unless typeof! res is 'Boolean'
        throw Error ".match method of permit #{@permit.name} must return a Boolean value, was: #{typeof! res}"

      return res
    else
      @debug "permit.ex-match function not found for permit: #{@permit}"
      false

  custom-match: ->
    if typeof! @permit.match is 'Function'
      res = @permit.match @access-request
      @debug 'custom-match', @permit.match, res
      if res.constructor is AccessMatcher
        return res.result!

      return true if res is undefined

      unless typeof! res is 'Boolean'
        throw Error ".match method of permit #{@permit.name} must return a Boolean value, was: #{typeof! res}"

      return res
    else
      @debug "permit.match function not found for permit: #{@permit}"
      false

  intersect-on: (partial) ->
    return false unless partial?

    if typeof! partial is 'Function'
      partial = partial!
    res = @intersect.on partial, @access-request
    res

  validate: ->
    # use object intersection test if permit has includes or excludes
    throw Error "PermitMatcher missing permit" unless @permit
    if @access-request? and @access-request is undefined
      throw Error "access-request is undefined"

lo.extend PermitMatcher, Debugger
Debugger      = require '../util' .Debugger
Permit        = require '../permit' .Permit
PermitFilter  = require './permit_filter'

# Uses a PermitFilter to filter which permits are to be considered
# given the incoming accessRequest
# permits becomes the set of filtered permits to be considered
# via allow and disallow. Both methods use testPermits to iterate through
# the filtered permits and test whether each permit allows/disallows for the
# given accessRequest.
# Note: Each permit can have both static rules and dynamic rules
# for each iteration, a permit applies its dynamic rules given the accessRequest
# and then test using all rules that apply for the given accessRequest

module.exports = class Allower implements Debugger

  # Uses PermitFiler to filter all registered permits that apply for the
  # given access request
  # @access request - object
  #
  # example:
  # { user: user, action: 'read', subject: book, ctx: {} }
  (@access-request, @debugging) ->
    # filter to only use permits that make sense for current access request
    @permits = PermitFilter.filter(@access-request)

  # test filtered permits for allowing the accessRequest
  # if any of them allows, then returns true (yes, sallow!), else false
  allows: ->
    @debug 'allows', @access-request
    @test-permits 'allows'

  # test filtered permits for disallowing the accessRequest
  # if any of them disallows, then returns true (yes, disallow!), else false
  disallows: ->
    @debug 'disallows', @access-request
    @testPermits 'disallows'

  # iterates through the filtered permits and test whether each permit allows/disallows for the
  # given accessRequest.
  # Note: Each permit can have both static rules and dynamic rules
  # for each iteration, a permit applies its dynamic rules given the accessRequest
  # and then test using all rules that apply for the given accessRequest
  test-permits: (allow-type) ->
    for permit in @permits
      @debug 'test permit', allow-type, permit
      @debug 'with rules', permit.rules
      permit.debug-on! if @debugging

      # apply dynamic rules
      permit.apply-rules @access-request #, true

      @debug 'permit rules'
      return true if permit[allow-type] @access-request
    false

Allower <<< Debugger

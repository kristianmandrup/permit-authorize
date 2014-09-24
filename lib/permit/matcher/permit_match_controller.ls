PermitMatcher = require './permit_matcher'

module.exports = class PermitMatchController
  (@context, @access-request, @debugging) ->

  permit-matcher: ->
    new PermitMatcher @context, @access-request, @debugging

  # See if this permit should apply (be used) for the given access request
  do-match: ->
    @debug 'matches', access-request
    @permit-matcher.match!

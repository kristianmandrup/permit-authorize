PermitMatcher   = require './permit_matcher'
AccessMatcher   = require '../../access_request' .matcher.AccessMatcher

mh = class MatchHelper
  (@context, @access-request) ->

  # uses cache via fingerprinting of accessRequest
  # returns AccessMatcher
  matching: ->
    fingerprint = accessRequest.fingerprint!
    unless @cached_matchers[fingerprint]
      @cached_matchers[fingerprint] = new AccessMatcher accessRequest

    @cached_matchers[fingerprint]

# Add helpers for AccessMatcher
access-matcher-delegates = ['match-on', 'user', 'role', 'roles', 'subject', 'subject-clazz', 'action', 'context', 'ctx']

module.exports = mh

for name in access-matcher-delegates
  mh[name] = (access-request, value) ->
    @matching(access-request)[helper] value

PermitMatcher   = require './permit_matcher'
AccessMatcher   = require '../../access_request' .matcher.AccessMatcher

mh = class MatchingContext
  (@context, @access-request) ->

  # uses cache via fingerprinting of accessRequest
  # returns AccessMatcher
  matching: (ar) ->
    ar ||= @access-request
    return @_cached-matching ar if typeof! ar.fingerprint is 'Function'
    @_access-matcher ar

  _cached-matching: (ar) ->
    fingerprint = ar.fingerprint!
    unless @cached_matchers[fingerprint]
      @cached_matchers[fingerprint] = @_access-matcher ar
    @cached_matchers[fingerprint]

  _access-matcher: (ar) ->
    @_am ||= new AccessMatcher ar

# Add helpers for AccessMatcher
access-matcher-delegates = ['match-on', 'user', 'role', 'roles', 'subject', 'subject-clazz', 'action', 'context', 'ctx']

module.exports = mh

for name in access-matcher-delegates
  mh[name] = (access-request, value) ->
    @matching(access-request)[helper] value

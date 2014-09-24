UsePermitMatcher   = require './use_permit_matcher'
AccessMatcher      = require '../../access_request' .matcher.AccessMatcher

module.exports =
  use-permit-matcher-class: UsePermitMatcher

  matcher: (access-request) ->
    new @permit-matcher-class @, access-request, @debugging

  # See if this permit should apply (be used) for the given access request
  matches: (access-request) ->
    @debug 'matches', access-request
    permit-matcher = @matcher(access-request)
    @debug 'permit matcher', permit-matcher
    permit-matcher.match!

  # uses cache via fingerprinting of accessRequest
  matching: (accessRequest) ->
    fingerprint = accessRequest.fingerprint!
    unless @cached_matchers[fingerprint]
      @cached_matchers[fingerprint] = new AccessMatcher accessRequest
    @cached_matchers[fingerprint]

  # TODO: refactor/simplify using delegate code generation

  match-on: (access-request, match-obj) ->
    @matching(access-request).match-on match-obj

  match-user: (access-request, user) ->
    @matching(access-request).user user

  match-role: (access-request, role) ->
    @matching(access-request).role role

  match-subject: (access-request, subj) ->
    @matching(access-request).subject subj

  match-subject-clazz: (clazz) ->
    @matching(access-request).subject-clazz: clazz

  match-action: (action) ->
    @matching(access-request).action action

  match-context: (ctx) ->
    @matches(access-request).context ctx

  match-ctx: (ctx) ->
    @matching(access-request).ctx ctx
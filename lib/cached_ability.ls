requires = require '../requires'

Ability       = requires.lib 'ability'

# Always one Ability per User
module.exports = class CachedAbility extends Ability
  (@user) ->
    super ...
    @user-key!

  @clear-cache = ->
    @@can-cache = {}
    @@cannot-cache = {}

  @can-cache = ->
    @_can-cache ||= {}

  @cannot-cache = ->
    @_cannot-cache ||= {}

  user-hash: requires.access-request 'fingerprints' .user-hash

  user-key: ->
    @user-key = @user-hash!

  # alias for: allowed-for
  can: (access-request) ->
    @debug 'can', access-request
    cached-res = @cached-result 'can', access-request
    return cached-res unless cached-res is void

    result = @allowed-for access-request
    @cache-result 'can', access-request, result
    @debug 'can-res', result
    result

  # alias for: not-allowed-for
  cannot: (access-request) ->
    @debug 'cannot', access-request
    cached-res = @cached-result 'cannot', access-request
    return cached-res unless cached-res is void

    result = @not-allowed-for access-request
    @cache-result 'cannot', access-request, result
    @debug 'cannot-res', result
    result

  cached-result: (act, access-request) ->
    cache-repo = @["#{act}Cache"]!
    acc-req-key = access-request.access-hash!
    cache-repo[acc-req-key]

  cache-result: (act, access-request, result)->
    cache-repo = @["#{act}Cache"]!
    acc-req-key = access-request.access-hash!
    cache-repo[acc-req-key] = result
    result

  # per user
  can-cache: ->
    Ability.can-cache![@user-key]

  cannot-cache: ->
    Ability.cannot-cache![@user-key]
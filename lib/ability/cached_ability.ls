Ability       = require './ability'
FingerPrinter = require '../access_request' .fingerprint.FingerPrinter
Debugger      = require '../util' .Debugger

# Always one Ability per User
class CachedAbility extends Ability
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

  user-hash: ->
    new FingerPrinter(user).user-hash!

  user-key: ->
    @user-key = @user-hash!

  authorize: (@act, ...args) ->
    @clear!
    if @has-cached-result! then return @cached-result! else @cache-result!
    @debug 'cannot-res', @auth-result!
    @auth-result!

  acc-req-key: ->
    @access-request!.fingerprint!

  has-cached-result: ->
    @cached-result! isnt void

  clear: ->
    super!
    @_last-result = void

  cached-result: ->
    @_last-result ||= @cache![@acc-req-key!]

  cache-result: ->
    @cache![@acc-req-key!] = @auth-result!

  cache: ->
    @["#{@act}Cache"]!

  # per user
  can-cache: ->
    @@can-cache![@user-key] || {}

  cannot-cache: ->
    @@cannot-cache![@user-key] || {}

CachedAbility <<< Debugger

module.exports = CachedAbility
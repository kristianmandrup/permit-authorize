Ability       = require './ability'
Debugger      = require '../util' .Debugger
RulesCache    = require '../rule' .cache.RulesCache

# Ability per User
module.exports =class CachedAbility extends Ability
  (@user) ->
    super ...
    @cache = new RulesCache @user
    @

  # currently only caches last result!?
  authorize: (@act, ...args) ->
    @clear!
    return @cached-result! if @has-cached-result!
    @cache-result!

  fingerprint: ->
    @access-request!.fingerprint!

  has-cached-result: ->
    @cached-result! isnt void

  clear: ->
    super!
    @_last-result = void

  cached-result: ->
    @_last-result ||= @cache![@fingerprint!]

  cache-result: ->
    @cache![@fingerprint!] = @auth-result!

  cache: ->
    @cache[@act]

Ability       = require './ability'
Debugger      = require '../util' .Debugger
RulesCache    = require '../rule' .cache.RulesCache

# Ability per User
module.exports =class CachedAbility extends Ability
  (@user) ->
    super ...
    @config-caches!
    @

  caches: {}

  config-caches: ->
    @caches['can']    = new RulesCache.init!
    @caches['cannot'] = new RulesCache.init!

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

  # for convenience it caches last cache fetch here
  # so we can check if it fetched from cache last time or not ;)
  # improve this to maintain a FIFO history stack of last n items fetched?
  cached-result: ->
    @_last-result ||= @cache!.get @fingerprint!

  cache-result: ->
    @cache!.set @fingerprint!, @auth-result!

  cache: ->
    @caches[@act]

requires = require '../requires'
lo  = requires.util 'lodash-lite'

permit-filter = requires.permit 'permit_filter'
Allower       = requires.lib 'allower'
AccessRequest = requires.lib 'access_request'
Debugger      = requires.lib 'debugger'

ArgNormalizer = requires.ability 'arg-normalizer'

# Always one Ability per User
module.exports = class Ability implements Debugger
  (@user) ->
    @validate-user!

  validate-user: ->
    if @user is void
      throw new Error "Ability must be for a User, was void"
    unless typeof! @user is 'Object'
      throw new Error "User must be an Object, was #{@user}"

  permits: ->
    permit-filter.filter @access-request!

  allower: ->
    new Allower @access-request!

  allowed: ->
    @allower!.allows!

  not-allowed: ->
    @allower!.disallows!

  # alias for: allowed-for
  can: (...@args) ->
    @authorize 'can'

  # alias for: not-allowed-for
  cannot: (...@args) ->
    @authorize 'cannot'

  auth-result: ->
    @_result ||= if @act is 'can' then @allowed! else @not-allowed!

  # alias for: allowed-for
  authorize: (@act) ->
    @clear!
    @debug 'can result:', @auth-result!
    @auth-result!

  clear: ->
    @_result = void
    @_access-request = void

  access-request:  ->
    @_access-request ||= AccessRequest.from @normalized-args!, @debugging

  normalized-args: ->
    @args = lo.flatten @args
    @debug 'normalize args', @args
    new ArgNormalizer(@args).set-user(@user).normalized!

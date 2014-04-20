requires = require '../requires'

_   = require 'prelude-ls'
lo  = require 'lodash'

permit-filter = requires.permit 'permit_filter'
Allower       = requires.lib 'allower'
AccessRequest = requires.lib 'access_request'
Debugger      = requires.lib 'debugger'

# Always one Ability per User
module.exports = class Ability implements Debugger
  (@user) ->

  # adds the user of the ability to the access-request object
  access-obj: (access-request) ->
    lo.merge access-request, {user : @user}

  permits: (access-request) ->
    permit-filter.filter access-request

  allower: (access-request) ->
    a = new Allower(@access-obj access-request)
    a.debug-on! if @debugging
    a

  allowed-for: (access-request) ->
    @allower(access-request).allows!

  not-allowed-for: (access-request) ->
    @allower(access-request).disallows!

  # alias for: allowed-for
  can: (access-request) ->
    @debug 'can', access-request
    c = @allowed-for access-request
    @debug 'can-res', c
    c

  # alias for: not-allowed-for
  cannot: (access) ->
    @debug 'cannot', access-request
    @not-allowed-for access-request

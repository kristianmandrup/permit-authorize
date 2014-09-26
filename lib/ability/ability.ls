PermitFilter = require '../allower' .PermitFilter
Allower       = require '../allower' .Allower
AccessRequest = require '../access_request' .AccessRequest
Debugger      = require '../util' .Debugger
Normalizer    = require '../access_request' .util.Normalizer

/*
# Ability of a user to perform an action on a subject
*/
module.exports = class Ability implements Debugger

  /*
  # @constructor
  # @param {string} user   - The user who requests access to perform
  # @param {string} author - The author of the book.
  */
  (@user, debug) ->
    @debug-on! if debug
    @_validate-user!

  /*
  # validates the user
  */
  _validate-user: ->
    unless typeof! @user is 'Object'
      throw new Error "User must be an Object, was #{@user}"

  # TODO: allow for more strategies!
  permits: ->
    @filter!

  filter: ->
    @permit-filter.filter!

  permit-filter: ->
    new PermitFilter @access-request

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

  # executes a user access verb (can/cannot)
  authorize: (@act) ->
    @clear!
    @debug 'can result:', @auth-result!
    @auth-result!

  clear: ->
    @_result = void
    @_access-request = void

  access-request:  ->
    @_access-request ||= AccessRequest.from @normalized!, @debugging

  normalized: ->
    # https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce#Example:_Flatten_an_array_of_arrays
    @args = @args.reduce (a, b) ->
      a.concat b

    @debug 'normalize args', @args
    new Normalizer(@args).set-user(@user).normalized!

Ability <<< Debugger

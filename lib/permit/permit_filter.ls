requires = require '../../requires'

_       = require 'prelude-ls'
lo      = require 'lodash'

Permit          = requires.lib 'permit'
PermitRegistry  = requires.permit 'permit_registry'

Debugger  = requires.lib 'debugger'

module.exports = class PermitFilter implements Debugger
  # go through all permits
  # and match on access being requested by user
  # if the permit matches, then we will later check to see
  # if the permit allows the action on the subject in the given context
  @filter = (access-request) ->
    self = @
    matching-fun = (permit) ->
      self.debug 'matching', permit, access-request
      unless permit.matches
        throw Error "Permit must have a .matches(access-request) method: #{permit}"
      permit.matches access-request

    permits = @permits!
    unless _.is-type 'Array', permits
      throw Error "permits which contain all registered permits, must be an Array, was: #{typeof permits}"

    @debug 'filter permits', permits, access-request
    res = _.filter matching-fun, permits
    @debug 'filtered', res
    res

  @permits = ->
    _.values PermitRegistry.permits

lo.extend PermitFilter, Debugger

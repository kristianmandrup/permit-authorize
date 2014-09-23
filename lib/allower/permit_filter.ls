values = require '../util/obj_util' .values

Debugger        = require '../util/debugger'
Permit          = require '../permit' .Permit
PermitRegistry  = require '../permit' .registry.PermitRegistry

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
    unless typeof! permits is 'Array'
      throw Error "permits which contain all registered permits, must be an Array, was: #{typeof permits}"

    @debug 'filter permits', permits, access-request
    res = permits.filter matching-fun
    @debug 'filtered', res
    res

  @permits = ->
    values @permit-source

  @permit-source = ->
    if PermitContainer.hasAny
      PermitContainer.active-containers-permits
    else
      PermitRegistry.permits

PermitFilter <<< Debugger

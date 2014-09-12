lo        = require '../util/lodash_lite'
Debugger  = require '../debugger'

Permit          = require '../permit'
PermitRegistry  = require '../permit/permit_registry'

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
    res = lo.filter permits, matching-fun
    @debug 'filtered', res
    res

  @permits = ->
    lo.values PermitRegistry.permits

lo.extend PermitFilter, Debugger

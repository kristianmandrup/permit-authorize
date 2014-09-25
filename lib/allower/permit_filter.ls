values = require '../util/obj_util' .values

Debugger        = require '../util/debugger'
Permit          = require '../permit' .Permit

module.exports = class PermitFilter implements Debugger
  (@access-request) ->

  # go through all permits
  # and match on access being requested by user
  # if the permit matches, then we will later check to see
  # if the permit allows the action on the subject in the given context
  filter: ->
    permits = @permits!
    unless typeof! permits is 'Array'
      throw Error "permits which contain all registered permits, must be an Array, was: #{typeof permits}"

    @debug 'filter permits', permits, @access-request
    res = permits.filter @create-matcher
    @debug 'filtered', res
    res

  create-matcher: ->
    self = @
    (permit) ->
      self.debug 'matching', permit, @access-request
      unless permit.matches
        throw Error "Permit must have a .matches(access-request) method: #{permit}"
      permit.matches @access-request


  permits: ->
    values @permit-source

  permit-source: ->
    if PermitContainer.hasAny
      @active-permits!
    else
      @all-permits!

  active-permits: ->
    PermitContainer.active-containers-permits

  all-permits: ->
    Permit.registry.permits

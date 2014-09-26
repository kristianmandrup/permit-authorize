values = require '../util' .object.values

Debugger        = require '../util/debugger'
Permit          = require '../permit' .Permit

module.exports = class PermitFilter implements Debugger
  (@access-request) ->

  # go through all permits
  # and match on access being requested by user
  # if the permit matches, then we will later check to see
  # if the permit allows the action on the subject in the given context
  filter: ->
    @_validate-permits!
    @debug 'filter', @permits!, @access-request
    @filter-permits!

  _validate-permits: ->
    unless typeof! @permits! is 'Array'
      throw Error "permits which contain all registered permits, must be an Array, was: #{typeof @permits!}"

  filter-permits: ->
    @permits!.filter @match-fun

  match-fun: ->
    (permit) ->
      return false if not permit.active
      return permit.matches @access-request if permit.matches
      permit

  permits: ->
    @_permits ||= values @permit-source

  permit-source: ->
    if PermitContainer.has-any
      @active-permits!
    else
      @all-permits!

  active-permits: ->
    PermitContainer.active-container-permits

  all-permits: ->
    Permit.registry.permits

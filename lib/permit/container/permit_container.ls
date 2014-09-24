# Holds a specific category of permits
# Common example is per domain, ie: admin, guest, authorized user
# Could also be by environment, ie: dev, test, prod
# This can be integrated with PermitFilter as you like

values = require '../../util' .object.values

module.exports = class PermitContainer
  (@name, @desc) ->
    @repo = {}
    @description = @desc
    @

  add: (permit) ->
    @repo[permit.name] = permit
    permit.container = @
    @

  remove: (thing) ->
    name = thing
    if typeof! thing is 'Object'
      name = thing.name
    unless @repo[name]
      throw new Error "Permit Repo has no entry for: #{name}"
    delete @repo[name]
    @

  activate: ->
    @active = true
    PermitContainer.add @
    @

  deactivate: ->
    @active = false
    PermitContainer.remove @
    @

  @add = (container) ->
    @active-containers[container.name] = container

  @remove = (container) ->
    delete @active-containers[container.name]

  @active-containers = {}

  @active-containers-list = ->
    values @active-containers

  @has-any = ->
    Object.keys @active-containers .length > 0


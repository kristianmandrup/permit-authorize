# Holds a specific category of permits
# Common example is per domain, ie: admin, guest, authorized user
# Could also be by environment, ie: dev, test, prod
# This can be integrated with PermitFilter as you like

module.exports = class PermitContainer
  (@name, @desc) ->
    @repo = {}

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
    @repo.delete name

  activate: ->
    active = true
    PermitContainer.add @

  deactivate: ->
    active = false
    PermitContainer.remove @

  @add = (container) ->
    @active-containers[container.name] =container

  @remove = (container) ->
    @active-containers.delete container.name

  @active-containers = []

  @active-containers-permits = ->
    values @active-containers

  @hasAny = ->
    @active-containers && @active-containers.index > 0


obj       = require '../../util' .object
values    = obj.values
Debugger  = require '../../util' .Debugger

extract-name = (thing) ->
  switch typeof! thing
  when 'Object'
    thing.name
  when 'String'
    thing
  default
    throw new Error "Can't find the name of #{thing}"

calc-name = (ctx, name) ->
  if name is undefined
    name = "Permit-#{ctx.permit-count!}"

  unless typeof! name is 'String'
    throw Error "Name of permit must be a String, was: #{name}"
  name

module.exports = class PermitRegistry implements Debugger
  (@permits = {}) ->

  get: (name) ->
    @permits[name] or throw Error("No permit '#{name}' is registered")

  unregister: (permit) ->
    name = extract-name permit
    delete @permits[name]

  register: (permit) ->
    name = calc-name @, permit.name
    # register permit
    @permits[name] = permit if @_may-register name
    permit.name = name
    @

  permit-count: ->
    Object.keys(@permits).length

  permit-list: ->
    values @permits

  clean-permits: ->
    for permit in @permit-list!
      permit.clean!

  clean: ->
    @permits = {}

  _may-register: (name) ->
    unless typeof! @permits is 'Object'
      throw Error "permits registry container must be an Object in order to store permits by name, was: #{@permits}"

    if @permits[name]
      throw Error "A Permit named: #{name} is already registered, please use a different name!"



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
  (@debugging = true) ->

  permits: {}

  get: (name) ->
    @permits[name] or throw Error("No permit '#{name}' is registered")

  unregister: (permit) ->
    name = extract-name permit
    delete @permits[name]

  register: (permit) ->
    @debug 'register', @permits, permit
    name = calc-name @, permit.name
    @debug 'permit name', name
    # register permit
    if @_may-register name
      @permits[name] = permit
    else
      @debug 'may not register permit:', name

    permit.name = name
    @debug 'registered', @permits, name
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
    not @permits[name]


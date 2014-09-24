obj       = require '../../util' .object
values    = obj.values
Debugger  = require '../../util' .Debugger

module.exports = class PermitRegistry implements Debugger
  (@permits = {}) ->
    @permit-counter = Object.keys @permits .length
    @

  calc-name: (name) ->
    if name is undefined
      name = "Permit-#{@permit-counter}"

    unless typeof! name is 'String'
      throw Error "Name of permit must be a String, was: #{name}"
    name

  get: (name) ->
    @permits[name] or throw Error("No permit '#{name}' is registered")

  register-permit: (permit) ->
    permit.name = @calc-name permit.name
    name = permit.name

    unless typeof! @permits is 'Object'
      throw Error "permits registry container must be an Object in order to store permits by name, was: #{@permits}"

    if @permits[name]
      throw Error "A Permit named: #{name} is already registered, please use a different name!"

    # register permit
    @permits[name] = permit
    @permit-counter = @permit-counter + 1

  clear-permits: ->
    @permits = {}
    @permit-counter = 0

  clear-all: ->
    @clear-permits!

  permit-list: ->
    values @permits

  clean-permits: ->
    for permit in @permit-list!
      permit.clean!

  clean-all: ->
    @clean-permits!

PermitRegistry <<< Debugger

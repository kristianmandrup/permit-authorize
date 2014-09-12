lo        = require '../util/lodash_lite'
Debugger  = require '../debugger'

# TODO: allow creation of multiple registries and select one to use per environment
todo = "allow creation of multiple registries and select one to use per environment"

module.exports = class PermitRegistry implements Debugger
  # constructor
  ->
    throw Error "PermitRegistry is currently a singleton (TODO: #{todo})"

  # class methods/variables (singleton)
  @permits = {}
  @permit-counter = 0

  @calc-name = (name) ->
    if name is undefined
      name = "Permit-#{@@permit-counter}"

    unless typeof! name is 'String'
      throw Error "Name of permit must be a String, was: #{name}"
    name

  @get = (name) ->
    @@permits[name] or throw Error("No permit '#{name}' is registered")

  @register-permit = (permit) ->
    permit.name = @calc-name permit.name
    name = permit.name

    unless typeof! @@permits is 'Object'
      throw Error "permits registry container must be an Object in order to store permits by name, was: #{@@permits}"

    if @@permits[name]
      throw Error "A Permit named: #{name} is already registered, please use a different name!"

    # register permit
    @@permits[name] = permit
    @@permit-counter = @@permit-counter+1

  @clear-permits = ->
    @@permits = {}
    @@permit-counter = 0

  @clear-all = ->
    @@clear-permits!

  @permit-list = ->
    lo.values @@permits

  @clean-permits = ->
    for permit in @@permit-list!
      permit.clean!

  @clean-all = ->
    @@clean-permits!


lo.extend PermitRegistry, Debugger
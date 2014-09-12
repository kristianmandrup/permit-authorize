lo        = require '../util/lodash_lite'
Permit    = require '../permit'

# makes an instance of a Permit class, adds specific functionality (such as rules) and registers the permit globally

# we should take class to use as base class an optional first argument
# use Permit class as default if first arg is a String (ie. name)
module.exports = (base-clazz, name, base-obj, debug) ->
  # tweak args if no base class as first arg
  if typeof! base-clazz is 'String'
    base-obj = name
    name = base-clazz
    base-clazz = Permit

  permit = new base-clazz name
  permit.debug-on! if debug is true

  if base-obj? and typeof! base-obj is 'Function'
    base-obj = base-obj!

  # extend permit with custom functionality
  if typeof! base-obj is 'Object'
    permit = permit.use base-obj
  permit.init!

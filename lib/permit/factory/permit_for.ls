# makes an instance of a Permit class with custom functionality and DSL rules etc.
module.exports = (base-clazz, name, base-obj, debug) ->
  pm = new PermitFactory base-clazz, name, base-obj, debug
  pm.create!
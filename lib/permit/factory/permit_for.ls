# makes an instance of a Permit class with custom functionality and DSL rules etc.
var PermitFactory

module.exports = (base-clazz, name, base-obj, debug) ->
  PermitFactory ||= require './permit_factory'
  pm = new PermitFactory base-clazz, name, base-obj, debug
  pm.create!
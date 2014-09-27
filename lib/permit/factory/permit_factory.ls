Debugger = require '../../util' .Debugger

module.exports = class PermitFactory implements Debugger
  (@base-clazz, @name, @base-obj, @debugging) ->
    @configure!

  configure: ->
    # tweak args if invalid base-clazz type
    if typeof! @base-clazz is 'String'
      @base-obj = @name
      @name = @base-clazz
      @base-clazz = @default-permit-class! # default permit

  default-permit-class: ->
    @dpc ||= require('../permit')

  create-permit: ->
    new @base-clazz @name, @debugging

  create: ->
    switch typeof! @base-obj
    # extend permit with custom functionality
    case 'Object' then @use @create-permit!, @base-obj
    default @create-permit!

  # used by permit-for to extend specific permit from base class (prototype)
  use: (permit, obj) ->
    obj = obj! if typeof! obj is 'Function'
    if typeof! obj is 'Object'
      permit <<< obj
    else
      throw Error "Can only extend permit with an Object, was: #{typeof! obj}"


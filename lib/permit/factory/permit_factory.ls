Debugger = require '../../util' .Debugger

module.exports = class PermitFactory implements Debugger
  (@base-clazz, @name, @base-obj, @debugging) ->
    @configure!
    @

  configure: ->
    # tweak args if invalid base-clazz type
    if typeof! @base-clazz is 'String'
      console.log 'configure'
      @debugging = @base-obj
      @base-obj = @name
      @name = @base-clazz
      @base-clazz = @default-permit-class! # default permit

  default-permit-class: ->
    @dpc ||= require('../permit')

  create-permit: ->
    new @base-clazz @name, @debugging

  create: ->
    @debug 'create', @base-obj
    @use @create-permit!, @base-obj

  # used by permit-for to extend specific permit from base class (prototype)
  use: (permit, obj) ->
    @debug 'use', permit, obj
    obj = obj! if typeof! obj is 'Function'
    @debug 'rules obj', obj
    if typeof! obj is 'Object'
      @debug 'extend', permit, 'with', obj
      permit <<< obj
    else
      throw Error "Can only extend permit with an Object, was: #{typeof! obj}"
    @debug 'extended', permit
    permit


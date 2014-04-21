requires = require '../../requires'
lo  = require 'lodash'

module.exports = class ArgNormalizer
  (@args) ->
    @args = [@args] if typeof! @args is 'Object'

  set-user: (@user) ->
    @

  user-obj: ->
    if @user? then {user: @user} else {}

  normalized: ->
    lo.extend @user-obj!, @normalized-obj!

  normalized-obj: ->
    @object! or @create-object!

  create-object: ->
    @ctx-obj! or @base-obj!

  ctx-obj: ->
    lo.extend(@base-obj!, ctx: @args.2) if @args.2

  base-obj: ->
   {action: @args.0, subject: @args.1}

  object: ->
    @args.0 if typeof! @args.0 is 'Object'

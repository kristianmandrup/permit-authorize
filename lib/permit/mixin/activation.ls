module.exports =
  auto-activate: true

  activate: ->
    @active = true
    @_register!

  deactivate: ->
    @active = false
    @_unregister!

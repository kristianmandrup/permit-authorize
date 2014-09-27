time = require './time'

module.exports =
  debugging: false

  debug: (msg) ->
    if @debugging
      console.log @constructor.display-name + ':'
      console.log ...

  debug-on: ->
    @debugging = true
    @

  timer-on: (methods) ->
    time.timer @, only: methods, except: [/debug.*/]
    @


  debug-off: ->
    @debugging = false
    @

lo = require 'lodash'

module.exports =
  debugging: false

  debug: (msg) ->
    if @debugging
      console.log @.constructor.display-name + ':'
      console.log ...

  debug-on: ->
    @debugging = true

  debug-off: ->
    @debugging = false

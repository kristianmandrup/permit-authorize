module.exports =
  debugging: false

  debug: (msg) ->
    if @debugging
      id  = @.constructor.display-name
      console.time-end id if @_last_time_id is id
      @_last_time_id = id
      console.time id
      console.log id + ':'
      console.log ...

  debug-on: ->
    @debugging = true

  debug-off: ->
    @debugging = false

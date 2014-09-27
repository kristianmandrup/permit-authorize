wrap-it = (object, key) ->
  fun = object[key]
  ->
    # set-timeout
    console.time key
    start-time = new Date
    fun.apply object, arguments
    console.time-end key

cloned-timer = (object, methods) ->
  methods ||= Object.keys object
  clone = {} <<< object
  for key in methods
    if typeof! object[key] is 'Function'
      clone[key] = wrap-it object, key
  clone

methods-of = require './introspect'

timer-on = (object, config = {}) ->
  methods = config.only
  proto-methods = Object.keys object.prototype if object.prototype
  proto-methods ||= []

  methods ||= methods-of object

  except-methods = config.except
  except-methods = [except] if typeof! except-methods is 'String'
  except-methods ||= []

  filtered-methods = methods.filter (meth) ->
    for exp in except-methods
      return false if meth is exp or meth.match exp
    typeof! object[meth] is 'Function'

  for key in filtered-methods
    if typeof! object[key] is 'Function'
      object[key] = wrap-it object, key
  object

module.exports =
  timer:        timer-on
  cloned-timer: cloned-timer


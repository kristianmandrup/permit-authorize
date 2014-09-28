util      = require '../../util'
Debugger  = util.Debugger

module.exports = class RuleCleaner implements Debugger
  (@container) ->
    @_validate!
    @

  _type: 'RuleCleaner'

  _validate: ->
    unless typeof! @container is 'Object'
      throw Error "Container must be an Object, was: #{@container}"

  clean-all: ->
    @clean 'can'
    @clean 'cannot'
    @

  # allow clean only can or cannot rules
  # if no argument, clean both
  clean: (act)->
    return @clean-all! if act is undefined
    unless act is 'can' or act is 'cannot'
      throw Error "Repo can only clear 'can' or 'cannot' rules, was: #{act}"

    @debug 'clean', act
    @container[act] = {}
    @

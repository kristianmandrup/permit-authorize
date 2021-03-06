lo        = require '../util/lodash_lite'
Debugger  = require '../debugger'

Intersect = require '../util/intersect'

class BaseMatcher implements Debugger
  (access-request) ->
    @set-access-request access-request
    @set-intersect!

  match: (value) ->
    false

  death-match: (name, value) ->
    return true if @[name] and value is void
    false

  set-access-request: (access-request) ->
    @access-request = if access-request then access-request else {}

  set-intersect: ->
    @intersect ||= Intersect()

lo.extend BaseMatcher, Debugger

module.exports = BaseMatcher
Debugger  = require '../../util' .Debugger
Intersect = require '../../util' .intersect

module.exports = class BaseMatcher implements Debugger
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

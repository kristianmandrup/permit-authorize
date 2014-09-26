# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

Debugger  = util.Debugger

RuleContainer   = require '../container' .RuleContainer

# TODO: Do we really need this wrapper?
module.exports = class RuleRepo implements Debugger
  (@name, @debugging) ->

  container: ->
    new RuleContainer @debugging

  display: ->
    console.log "name:", @name
    @container.display

  register: (act, actions, subjects) ->
    @container.register act, actions, subjects

  match: (act, access-request) ->
    @container.match act, access-request .match!

  clean: ->
    @container.clean!


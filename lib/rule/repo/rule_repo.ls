# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!

Debugger        = require '../../util' .Debugger
RuleContainer   = require '../container' .RuleContainer

# Why a repo?
# A repo could have multiple containers and control access to containers

module.exports = class RuleRepo implements Debugger
  (@name, @debugging = true) ->

  _type: 'RuleRepo'

  container: ->
    @_container ||= new RuleContainer @debugging

  can-rules: ->
    @container!.can

  cannot-rules: ->
    @container!.cannot

  display: ->
    console.log "name:", @name
    @container!.display

  register: (act, actions, subjects) ->
    @container!.register act, actions, subjects

  match: (act, access-request) ->
    @container!.match act, access-request .match!

  clean: ->
    @container!.clean!
    @




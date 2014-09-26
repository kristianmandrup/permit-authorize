util      = require '../../util'

Debugger  = util.Debugger

module.exports = class RuleContainer implements Debugger
  (@debugging) ->

  can: {}
  cannot: {}

  register: (act, actions, subjects) ->
    @registrator.register-rule act, actions, subjects

  match: (act, access-request) ->
    @matcher act, access-request .match!

  clean: ->
    @cleaner.clean!

  matcher: (act, access-request) ->
    new RuleMatcher @container, act, access-request

  cleaner: ->
    @_cleaner ||= new RepoCleaner @container

  registrator: ->
    @_registrator ||= new RuleRegistrator @container

  display: ->
    console.log "can-rules:", @can
    console.log "cannot-rules:", @cannot

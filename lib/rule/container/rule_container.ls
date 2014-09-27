util      = require '../../util'
Debugger  = util.Debugger

RuleCleaner       = require './rule_cleaner'
RuleRegistrator   = require './rule_registrator'

module.exports = class RuleContainer implements Debugger
  (@debugging) ->

  can: {}
  cannot: {}

  register: (act, actions, subjects) ->
    @registrator.register-rule act, actions, subjects

  match: (act, access-request) ->
    @matcher act, access-request .match!

  clean: ->
    @cleaner!.clean!

  matcher: (act, access-request) ->
    new RuleMatcher @, act, access-request

  cleaner: ->
    @_cleaner ||= new RuleCleaner @

  registrator: ->
    @_registrator ||= new RuleRegistrator @

  display: ->
    console.log "can-rules:", @can
    console.log "cannot-rules:", @cannot

# A general purpose rule repository
# contains can and cannot rules
# You can register rules of the type: action, list of subjects
# Then you can match an access-request (action, subject)
# Simple!
util      = require '../../util'

Debugger  = util.Debugger

camel-case  = util.string.camel-case
normalize   = util.normalize

module.exports = class RuleRepo implements Debugger
  (@name, @debugging) ->

  can-rules: {}
  cannot-rules: {}

  display: ->
    console.log "name:", @name
    console.log "can-rules:", @can-rules
    console.log "cannot-rules:", @cannot-rules

  register-rule: (act, actions, subjects) ->
    @registrator.register-rule act, actions, subjects

  cleaner: ->
    @_cleaner ||= new RepoCleaner @

  registrator: ->
    @_registrator ||= new RepoRegistrator @

  match-rule: (act, access-request) ->
    @rule-matcher(act, access-request).match!

  rule-matcher: (act, access-request) ->
    new RuleMatcher act, access-request


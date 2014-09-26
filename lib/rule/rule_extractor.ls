util        = require '../util'
array       = util.array
#contains  = array.contains
#object    = util.object
unique      = array.unique
normalize   = util.normalize
camelize    = util.string.camel-case

Debugger  = util.Debugger

module.exports = class RuleExtractor implements Debugger
  (@rule-container, @action, @subjects, @debugging) ->

  extract: ->
    @register-action-subjects @action-subjects!, @unique-subjects!

  register-action-subjects: (action-container, subjects) ->
    @debug "register action subjects", action-container, subjects
    unique action-container.concat(subjects)

  unique-subjects: ->
    unique @rule-subjects!

  action-subjects: ->
    as = @rule-container[@action]
    @debug 'as', as
    if typeof! as is 'Array' then as else []

  rule-subjects: ->
    @_rule-subjects ||= @__rule-subjects!

  # TODO: refactor
  __rule-subjects: ->
    rule-subjects = @rule-container[@action] || []

    @debug 'rule-subjects', rule-subjects

    rule-subjects = rule-subjects.concat @normalized-subjects!

    @debug 'rule-subjects', rule-subjects

    rule-subjects.map (subject) ->
      val = camelize subject
      if val is 'Any' then '*' else val

  normalized-subjects: ->
    @_normalized-subjects ||= normalize @subjects
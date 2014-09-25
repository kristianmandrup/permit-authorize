module.exports = class RuleExtractor
  (@rule-container, @action, @subjects) ->

  extract: ->
    @register-action-subjects @action-subjects!, @unique-subjects!

  register-action-subjects: (action-container, subjects) ->
    @debug "register action subjects", action-container, subjects
    unique action-container.concat(subjects)

  unique-subjects: ->
    unique @rule-subjects

  action-subjects: ->
    as = @rule-container[action]
    if typeof! as is 'Array' then as else []

  rule-subjects: ->
    @_rule-subjects ||= @__rule-subjects!

  # TODO: refactor
  __rule-subjects: ->
    rule-subjects = @rule-container[@action] || []

    subjects = normalize @subjects
    rule-subjects = rule-subjects.concat subjects

    rule-subjects.map (subject) ->
      val = camel-case subject
      if val is 'Any' then '*' else val

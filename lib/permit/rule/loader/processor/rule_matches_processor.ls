module.exports = class RuleMatchesProcessor
  (@obj) ->
    unless @obj['matches']
      throw new Error("Rules are missing a 'matches' root key");

    @rules = @obj['matches']
    @processed-rules = {}
    process!

  result: ->
    {'matches': @processed-rules}

  process: ->
    @debug "process", @rules
    for key of @rules
      @validate key
      @processed-rules[key] = process-rule @rules[key]

  validate: (key) ->
    unless valid(key)
      throw new Error("Invalid rule identifier #{key}, must be one of #{valid-keys}")

  valid-keys: ['role', 'roles', 'subject', 'subjects', 'action', 'actions', 'user', 'ctx']

  valid: (key) ->
    if find valid-keys, key then true else false

  # TODO: perform some basic validation on string values
  process-matches: (matches) ->
    unless valid-type matches
      throw new Error "Invalid matches type: #{matches}"
    unless validate-values matches
      throw new Error "Invalid matches value: #{matches}"

  valid-type: (value) ->
    find ['String', 'Array'], typeof!(value)

  validate-values: (matches) ->
    validate-str(matches) or validate-list(matches)

  validate-str: (value) ->
    return false unless typeof! matches is 'String'
    true # TODO: only alphanumeric

  validate-list: (value) ->
    return false unless typeof! matches is 'Array'
    true # TODO: only alphanumeric



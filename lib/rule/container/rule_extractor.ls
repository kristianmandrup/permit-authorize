util        = require '../../util'
array       = util.array
#contains  = array.contains
#object    = util.object
unique      = array.unique
normalize   = util.normalize
camelize    = util.string.camel-case

Debugger  = util.Debugger

normalized = (subjects) ->
  subjects.map (subject) ->
    val = camelize subject
    if val is 'Any' then '*' else val

module.exports = class RuleExtractor implements Debugger
  (@container, @action, @subjects, @debugging) ->

  _type: 'RuleExtractor'

  extract: ->
    @debug "register action subjects", @action-subjects!, @unique-subjects!
    unique normalized(@action-subjects!).concat @unique-subjects!

  unique-subjects: ->
    unique @normalized-subjects!

  action-subjects: ->
    @container[@action] || []

  normalized-subjects: ->
    @_normalized-subjects ||= normalized(normalize @subjects)
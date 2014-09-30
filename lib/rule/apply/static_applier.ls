RulesApplier = require './rules_applier'
util         = require '../util'

module.exports = class StaticApplier
  (@execution-context, @rules, @debugging) ->
    # super ...
    @debug 'ctx:', @execution-context, 'rules:', rules
    @

  _type: 'StaticApplier'

  # only the static rules
  apply: ->
    unless util.valid-rules @rules
      # throw Error "No rules defined for permit: #{@name}"
      @debug 'invalid permit rules could not be applied'
      return

    @debug 'applying rules', @rules, typeof! @rules
    @function-rules! or @object-rules!
    @

  function-rules: ->
    @rules! if typeof! @rules is 'Function'

  object-rules: ->
    @apply-rules! if typeof! @rules is 'Object'

  no-rules: ->
    throw Error "rules must be a Function or an Object, was: #{@rules}"

  # apply rules for key 'default:'
  #
  # rules:
  #   static: ->
  #     @ucan ...
  apply-rules: (name = 'static') ->
    @debug 'apply-rules', name
    @apply-rules-for name
    @

  apply-rules-for: (name) ->
    @rules-applier!.apply name

  rules-applier: ->
    @_rules-applier ||= new RulesApplier execution-context, rules, debugging
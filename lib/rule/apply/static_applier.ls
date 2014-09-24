RulesApplier = require './rules_applier'
util         = require '../util'

module.exports = class StaticApplier extends RulesApplier
  (@execution-context, @rules, @debugging) ->
    super ...
    @debug 'StaticApplier ctx:', @execution-context
    @

  # only the static rules
  apply-rules: ->
    unless util.valid-rules @rules
      # throw Error "No rules defined for permit: #{@name}"
      @debug 'invalid permit rules could not be applied'
      return

    @debug 'applying rules', @rules

    switch typeof @rules
    when 'function'
      @rules!
    when 'object'
      @apply-default-rules!

    else
      throw Error "rules must be a Function or an Object, was: #{@rules}"
    @

  # apply rules for key 'default:'
  #
  # rules:
  #   default: ->
  #     @ucan ...

  apply-default-rules: ->
    @debug 'apply-default-rules'
    @apply-rules-for 'default'
    @

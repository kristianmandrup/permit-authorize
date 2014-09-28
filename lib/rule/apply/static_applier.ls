RulesApplier = require './rules_applier'
util         = require '../util'

module.exports = class StaticApplier extends RulesApplier
  (@execution-context, @rules, @debugging) ->
    super ...
    @debug 'ctx:', @execution-context, 'rules:', rules
    @

  # only the static rules
  apply-rules: ->
    unless util.valid-rules @rules
      # throw Error "No rules defined for permit: #{@name}"
      @debug 'invalid permit rules could not be applied'
      return

    @debug 'applying rules', @rules, typeof! @rules
    @function-rules! or @object-rules! or @no-rules!
    @

  function-rules: ->
    @apply-default-rules! if typeof! @rules is 'Function'

  object-rules: ->
    @rules! if typeof! @rules is 'Object'

  no-rules: ->
    throw Error "rules must be a Function or an Object, was: #{@rules}"


  # apply rules for key 'default:'
  #
  # rules:
  #   default: ->
  #     @ucan ...

  apply-default-rules: ->
    @debug 'apply-default-rules'
    @apply-rules-for 'default'
    @

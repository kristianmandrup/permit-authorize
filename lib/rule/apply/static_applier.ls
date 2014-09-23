RulesApplier = require './rules_applier'

module.exports = class StaticApplier extends RulesApplier
  (@rules) ->

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

  apply-access-rules: ->
    @debug 'apply access rules on', @
    @apply-action-rules!
    @apply-user-rules!
    @apply-ctx-rules!
    @

  # should iterate through rules object recursively and execute any function found
  apply-all-rules: ->
    switch typeof @rules
    when 'object'
      rules = @rules
      ctx = @
      for key of rules
        util.recurse rules[key], ctx
    else
      throw Error "rules must be an Object was: #{typeof @rules}"
    @

  apply-default-rules: ->
    @debug 'apply-default-rules'
    @apply-rules-for 'default'
    @

  apply-rules-for: (name, context) ->
    @debug "apply rules for #{name} in context: #{context}"

    if typeof! name is 'Object'
      @apply-obj-rules-for name, context

    unless typeof! name is 'String'
      @debug "Name to apply rules for must be a String, was: #{typeof name} : #{name}"
      return @
      # throw Error "Name to appl rules for must be a String, was: #{name}"

    rules = @rules-accessor.context-rules(context)

    named-rules = rules[name]
    if typeof! named-rules is 'Function'
      named-rules.call @
    else
      @debug "rules key for #{name} should be a function that resolves one or more rules"
    @
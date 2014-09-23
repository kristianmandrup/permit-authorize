util        = require '../util'

# Execute all rules of a particular name (optionally within specific context, such as area, action or role)
#
# apply-rules-for 'read', 'action' - will execute the rules in... rules.action.read
# apply-rules-for 'read' - will execute the rules in rules.read
#
# rules:
#   action:
#     read: ->
#     ....
#   role:
#     admin: ->
#     guest: ->
#   area:
#     admin: ->

# Base class for Dynamic- and StaticRulesApplier
module.exports = class RulesApplier
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
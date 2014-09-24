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

Debugger          = require '../../util' .Debugger
ExecutionContext  = require './execution_context'

# Base class for Dynamic- and StaticRulesApplier
module.exports = class RulesApplier implements Debugger
  (@repo, @rules, @debugging) ->
    @execution-context = new ExecutionContext @repo

  # TODO: extract into module
  valid-request: ->
    return false if not @access-request
    if Object.keys(@access-request).length > 0 then true else false

  context-rules: (name)->
    @debug 'context rules', name
    if typeof! name is 'Object'
      return name

    return @rules unless typeof! name is 'String'
    if typeof! @rules[name] is 'Object'
      @rules[name]
    else
      @debug "no such rules context: #{name}", @rules
      @rules

  # should iterate through rules object recursively and execute any function found
  apply-all-rules: ->
    switch typeof @rules
    when 'object'
      rules = @rules
      ctx = @execution-context
      for key of rules
        util.recurse rules[key], ctx
    else
      throw Error "rules must be an Object was: #{typeof @rules}"
    @
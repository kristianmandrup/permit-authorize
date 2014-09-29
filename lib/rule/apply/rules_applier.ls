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
utily             = require '../../util'
subject           = utily.subject
Debugger          = utily.Debugger

ExecutionContext  = require './execution_context'
inspect           = require 'util' .inspect

# Base class for Dynamic- and StaticRulesApplier
module.exports = class RulesApplier implements Debugger
  (@execution-context, @rules, @debugging) ->
    @_validate!
    @

  _validate: ->
    unless @execution-context.ucan and @execution-context.ucannot
      throw Error "Execution context must have ucan and ucannot methods for executing rules, was: #{inspect @execution-context}"

  repo: ->
    @execution-context.repo

  apply-rules-for: (name, context) ->
    @debug "apply rules for #{name} in context:", context

    if typeof! name is 'Object'
      @apply-obj-rules-for name, context

    unless typeof! name is 'String'
      @debug "Name to apply rules for must be a String, was: #{typeof name} : #{name}"
      return @
      # throw Error "Name to appl rules for must be a String, was: #{name}"

    rules = @context-rules context

    named-rules = rules[name]
    @debug 'named rules', named-rules
    if typeof! named-rules is 'Function'
      @debug 'call rules in', @execution-context, @execution-context.constructor.display-name
      named-rules.call @execution-context, @access-request
    else
      @debug "rules key for #{name} should be a function that resolves one or more rules"
    @

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

  apply-obj-rules-for: (obj, context) ->
    @debug 'apply-obj-rules-for'
    rules = @context-rules context

    @debug 'apply-obj-rules-for', obj, context, rules

    obj-keys = Object.keys obj
    is-user =  subject(obj).clazz is 'User'

    if is-user
      obj-keys = ['name', 'role']

    for key of obj-keys
      val = obj[key]

      if is-user
        @apply-rules-for val, context

      key-rules = rules[key]
      @apply-rules-for val, key-rules


  # should iterate through rules object recursively and execute any function found
  apply-all-rules: ->
    switch typeof @rules
    when 'object'
      rules = @rules
      for key of rules
        util.recurse rules[key], @execution-context
    else
      throw Error "rules must be an Object was: #{typeof @rules}"
    @
RulesApplier = require './rules_applier'

module.exports = class DynamicApplier extends RulesApplier
  (@repo, @rules, @debugging) ->
    super ...

  apply-rules-for: (name, context) ->
    @debug "apply rules for #{name} in context: #{context}"

    if typeof! name is 'Object'
      @apply-obj-rules-for name, context

    unless typeof! name is 'String'
      @debug "Name to apply rules for must be a String, was: #{typeof name} : #{name}"
      return @
      # throw Error "Name to appl rules for must be a String, was: #{name}"

    rules = @context-rules(context)

    named-rules = rules[name]
    if typeof! named-rules is 'Function'
      named-rules.call @execution-context, @access-request
    else
      @debug "rules key for #{name} should be a function that resolves one or more rules"
    @

  apply-obj-rules-for: (obj, context) ->
    rules = @rules-accessor.context-rules(context)

    @debug 'apply-obj-rules-for', obj, context, rules

    obj-keys = Object.keys(obj)

    if obj.clazz is 'User'
      obj-keys = ['name', 'role']

    for key of obj-keys
      val = obj[key]

      if obj.clazz is 'User'
        @apply-rules-for val, context

      key-rules = rules[key]
      @apply-rules-for val, key-rules

  # for more advances cases, also pass context 'action' as 2nd param
  apply-action-rules: ->
    @apply-rules-for @action!
    @apply-rules-for @action!, 'action'
    @

  # typically used for role specific rules:
  # rules:
  #   admin: ->
  #     @ucan 'manage', '*'
  #
  # apply-rules-for user.role
  #
  # but could also be used for user specific rules,
  # such as on user name, email or whatever, even age (minor < 18y old!?)
  #
  apply-user-rules: ->
    @apply-rules-for @user!
    @apply-rules-for @user!, 'user'
    @

  apply-subject-rules: ->
    @apply-rules-for @subject!
    @apply-rules-for @subject!, 'subject'
    @

  # such as where on the site is the user?
  # guest area, member area? admin area?
  # which rules should apply?
  # rules:
  #   area:
  #     admin: ->
  #       @ucan 'manage', '*'
  #
  #
  apply-ctx-rules: ->
    @apply-rules-for @ctx!
    @apply-rules-for @ctx!, 'ctx'
    @apply-rules-for @ctx!, 'context'
    @

  apply-context-rules: ->
    @apply-ctx-rules!

  apply-access-rules: ->
    @debug 'apply access rules on', @access-request
    @apply-action-rules!
    @apply-user-rules!
    @apply-ctx-rules!
    @

  apply-default-rules: ->
    @debug 'apply-default-rules', @access-request, @valid-request!
    if typeof! @access-request is 'Object' and @valid-request!
      @apply-access-rules!
    else
      @apply-rules-for 'default'
    @
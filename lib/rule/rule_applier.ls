# Used to apply a set of rules (can and cannot rules)
# typically this is via a rules: key on a permit
# The permit can be setup to either apply all rules, (iterating through the rules object)
# or just apply a subset depending on the context (fx the action of the incoming access-request)

requires  = require '../../requires'
lo        = require 'lodash'

Debugger  = requires.lib 'debugger'

recurse = (key, val, ctx) ->
  switch typeof! val
  when 'Function'
    val.call ctx
  when 'Object'
    _.each(val, recurse, ctx)

valid_rules = (rules)->
  _.is-type('Object', rules) or _.is-type('Function', rules)

# To apply a rule, means to execute the .can or .cannot statement in order to add one or more entries
# to the corresponding can-rules or cannot-rules object in the rule-rep
module.exports = class RuleApplier implements Debugger
  (@repo, @rules, @access-request, @debugging) ->
    unless _.is-type('Object', @repo)
      throw Error "RuleApplier must be passed a RuleRepo, was: #{@repo}"

    unless valid_rules @rules
      throw Error "RuleApplier must be passed the rules to be applied, was: #{@rules}"

    unless @access-request is undefined or _.is-type 'Object', @access-request
      throw Error "AccessRequest must be an Object, was: #{@access-request}"
    @debugging = @debugging

  action: ->
    @access-request?.action

  user: ->
    @access-request?.user

  subject: ->
    @access-request?.subject

  ctx: ->
    @access-request?.ctx

  can-rules: ->
    @repo.can-rules

  cannot-rules: ->
    @repo.cannot-rules

  # Execute all rules of a particular name (optionally within specific context, such as area, action or role)
  #
  # apply-rules-for 'read', 'action' - will execute the rules in... rules.action.read
  # apply-rules-for 'read' - will execute the rules in rules.read
  #
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
  #     guest: ->
  #     member: ->
  #
  apply-rules-for: (name, context) ->
    @debug "apply rules for #{name} in context: #{context}"

    if _.is-type 'Object' name
      @apply-obj-rules-for name, context

    unless _.is-type 'String' name
      @debug "Name to apply rules for must be a String, was: #{typeof name} : #{name}"
      return @
      # throw Error "Name to appl rules for must be a String, was: #{name}"

    rules = @context-rules(context)

    named-rules = rules[name]
    if _.is-type 'Function', named-rules
      named-rules.call @, @access-request
    else
      @debug "rules key for #{name} should be a function that resolves one or more rules"
    @

  apply-obj-rules-for: (obj, context) ->
    rules = @context-rules(context)

    @debug 'apply-obj-rules-for', obj, context, rules

    obj-keys = _.keys(obj)

    if obj.clazz is 'User'
      obj-keys = ['name', 'role']

    self = @
    obj-keys.each (key) ->
      val = obj[key]

      if obj.clazz is 'User'
        self.apply-rules-for val, context

      key-rules = rules[key]
      self.apply-rules-for val, key-rules


  context-rules: (context)->
    if _.is-type 'Object', context
      return context

    return @rules unless _.is-type 'String', context
    if _.is-type 'Object' @rules[context]
      @rules[context]
    else
      @debug "no such rules context: #{context}", @rules
      @rules


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

  valid-request: ->
    not lo.is-empty @access-request

  apply-default-rules: ->
    @debug 'apply-default-rules', @access-request, @valid-request!
    if _.is-type('Object', @access-request) and @valid-request!
      @apply-access-rules!
    else
      @apply-rules-for 'default'
    @


  apply-rules: ->
    unless valid_rules @rules
      # throw Error "No rules defined for permit: #{@name}"
      @debug 'invalid permit rules could not be applied'
      return

    @debug 'applying rules', @rules, 'for', @access-request

    switch typeof @rules
    when 'function'
      @rules!
    when 'object'
      @apply-default-rules!

    else
      throw Error "rules must be a Function or an Object, was: #{@rules}"
    @

  apply-access-rules: ->
    @debug 'apply access rules on', @access-request
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
      self = @
      lo.each _.keys(rules), (key) ->
        self.recurse key, rules[key], ctx
    else
      throw Error "rules must be an Object was: #{typeof @rules}"
    @

  # so as not to be same name as can method used "from the outside, ie. via Ability"
  # for the functions within rules object, they are executed with the rule applier as this (@) - ie. the context
  # and thus have @ucan and @ucannot available within that context!
  # for the @apply-action-rules, we could return a function, where the current action is also in the context,
  # and is the default action for all @ucan and @ucannot calls!!
  ucan: (actions, subjects, ctx) ->
    @repo.register-rule 'can', actions, subjects, ctx

  ucannot: (actions, subjects, ctx) ->
    @repo.register-rule 'cannot', actions, subjects, ctx


lo.extend RuleApplier, Debugger
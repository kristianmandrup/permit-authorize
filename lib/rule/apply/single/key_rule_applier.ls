util        = require '../../../util'
Debugger    = util.Debugger
ApplyMixin  = require './apply_mixin'

module.exports = class KeyRuleApplier implements Debugger
  (@name, @context, @debugging) ->
    @rules = @context-rules context
    @debug "apply rules for #{name} in context:", context
    @

  _type: 'KeyRuleApplier'

  apply: ->
    @apply-obj-rules! or @apply-named-rules!

  apply-named-rules: ->
    @debug 'apply named rules', @named-rules!
    @call-function! or @no-function!

  call-function: ->
    if typeof! @named-rules! is 'Function'
      @debug 'call rules in', @execution-context
      named-rules.call @execution-context, @access-request
    @

  no-function: ->
    @debug "rules key for #{name} should be a function that resolves one or more rules"
    @

  named-rules: ->
    @_named-rules ||= @rules[@name]

  apply-obj-rules: ->
    object = name
    @apply-obj-rules-for object, context if typeof! name is 'Object'


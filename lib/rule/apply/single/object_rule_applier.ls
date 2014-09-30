util        = require '../../../util'
Debugger    = util.Debugger
ApplyMixin  = require './apply_mixin'

module.exports = class ObjectRuleApplier implements ApplyMixin, Debugger
  (@object, @context, @debugging) ->
    @_validate!
    @configure!
    @debug 'object:', @object, 'context:', @context, 'rules:', @rules
    @

  _type: 'ObjectRuleApplier'

  _validate: ->
    unless typeof! @object is 'Object'
      throw Error "object must be an Object, was: #{@object}"

  configure: ->
    @rules = @context-rules context
    @object-keys = Object.keys object

  apply: ->
    @iterate @keys!

  keys: ->
    @user-keys! or @object-keys

  iterate: (obj-keys) ->
    for key in obj-keys
      @apply-key key

  apply-key: (key) ->
    value = @object[key]
    @debug 'object value', value, 'for', key
    @apply-rules-for value, @context-for key

  context-for: (key) ->
    if @is-user! then @context else @rules[key]

  user-keys: ->
    ['name', 'role'] if @is-user!

  is-user: ->
    @_is-user ||= subject(@object).clazz is 'User'
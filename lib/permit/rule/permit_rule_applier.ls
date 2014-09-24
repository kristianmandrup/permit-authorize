RulesAccessor = require '../../rule' .RulesAccessor
camel-case    = require '../../util' .string.camel-case
Debugger      = require '../../util' .Debugger

module.exports = class PermitRuleApplier implements Debugger
  (@permit, @debugging) ->
    @applied-rules = false
    @rules = @permit.rules

  clean: ->
    @applied-rules = false

  static-applier: ->
    StaticApplier = require '../../rule' .apply.StaticApplier
    new StaticApplier @execution-context!, @rules, @debugging

  dynamic-applier: ->
    DynamicApplier = require '../../rule' .apply.StaticApplier
    new DynamicApplier @execution-context!, @rules, @access-request, @debugging

  execution-context: ->
    @_xcuter ||= @permit.rule-repo

  rule-applier: ->
    new @rules-applier.clazz @permit, @access-request, @debugging

  # TODO: put in module
  validate-access-request: ->
    unless typeof! @access-request is 'Object'
      throw Error "Invalid access reques #{@access-request}, must be an Object"

  applier-for: (type) ->
    @["#{type}Applier"]!

  # always called (can be overridden for custom behavior)
  apply-rules: (type = 'static', force) ->
    @["apply#{camel-case type}Rules"] force

  apply-dynamic-rules: ->
    @applier-for('dynamic').apply-rules!

  # @force - set to force re-application of static rules
  apply-static-rules: (force) ->
    unless @applied-rules and not force
      @debug 'permit apply static rules'
      # dynamic
      @applier-for('static').apply-rules!
      @applied-static-rules = true
    else
      @debug 'static rules already applied before', @applied-static-rules


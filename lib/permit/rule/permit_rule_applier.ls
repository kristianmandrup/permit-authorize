RulesAccessor = require '../../rule' .RulesAccessor

module.exports = class PermitRuleApplier
  (@permit, @debugging) ->
    @applied-rules = false
    @debug-on! if @debugging

  clean: ->
    @applied-rules = false

  rules-applier:
    clazz: RulesAccessor

  rule-applier: ->
    new @rules-applier.clazz @permit, @access-request, @debugging

  # put in module
  validate-access-request: ->
    unless typeof! @access-request is 'Object'
      throw Error "Invalid access reques #{@access-request}, must be an Object"


  # always called (can be overridden for custom behavior)
  apply-rules: (force) ->
    unless @applied-rules and not force
      @debug 'permit apply rules', @access-request
      @rule-applier(@access-request).apply-rules!
      @applied-rules = true
    else
      @debug 'rules already applied before', @applied-rules


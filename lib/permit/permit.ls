Debugger        = require '../util/debugger'

/*
PermitRegistry  = require './registry'  .permit_registry
PermitAllower   = require '../allower'  .PermitAllower
RuleApplier     = require './rule'      .RuleApplier
RuleRepo        = require './rule'      .RuleRepo

matchers        = require '../access_request' .matcher

UserMatcher     = matchers.UserMatcher
SubjectMatcher  = matchers.SubjectMatcher
ActionMatcher   = matchers.ActionMatcher
ContextMatcher  = matchers.ContextMatcher
AccessMatcher   = matchers.AccessMatcher

PermitMatch     = require './permit_match_mixin'
PermitAllow     = require './permit_allow_mixin'
PermitRuleApply = require './permit_rule_apply_mixin'
PermitCompileStatic = require './permit_compile_static'
*/

class Permit implements Debugger
  # Registers a permit in the PermitRegistry by name
  # @name - String
  # @description -String

  (@name, @description = '', @debugging) ->
    PermitRegistry.register-permit @
    @rule-repo = new RuleRepo @name
    @rule-applier = new PermitRuleApplier @, @debugging
    @use-permit-matcher = new UsePermitMatcher @, @access-request
    @permit-allower = new PermitAllower @rule-repo
    @

  # get a named permit
  @get = (name) ->
    PermitRegistry.get name

  # applies static rules
  # configures matchers and
  # pre-compiles static rules that match
  init: ->
    @debug 'permit init'
    @rule-applier.apply-static-rules!
    @configure-matchers!
    @

  clean: ->
    @rule-repo.clean!
    @rule-applier.clean!

  # used by permit-for to extend specific permit from base class (prototype)
  use: (obj) ->
    obj = obj! if typeof! obj is 'Function'
    if typeof! obj is 'Object'
      @ <<< obj
    else throw Error "Can only extend permit with an Object, was: #{typeof! obj}"

  # default empty rules
  rules: ->

  can-rules: ->
    @rule-repo.can-rules

  cannot-rules: ->
    @rule-repo.cannot-rules

Permit <<< Debugger

module.exports = Permit
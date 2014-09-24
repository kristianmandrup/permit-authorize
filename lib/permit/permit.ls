Debugger        = require '../util/debugger'

/*




matchers        = require '../access_request' .matcher

UserMatcher     = matchers.UserMatcher
SubjectMatcher  = matchers.SubjectMatcher
ActionMatcher   = matchers.ActionMatcher
ContextMatcher  = matchers.ContextMatcher
AccessMatcher   = matchers.AccessMatcher

PermitMatch     = require './permit_match_mixin'
PermitAllow     = require './permit_allow_mixin'

PermitCompileStatic = require './permit_compile_static'
*/
var RuleRepo, RuleApplier, PermitRegistry, UsePermitMatcher, PermitAllower

module.exports = class Permit implements Debugger
  # Registers a permit in the PermitRegistry by name
  # @name - String
  # @description -String

  (@name, @description = '', @debugging) ->
    RuleRepo          := require '../rule'      .repo.RuleRepo
    RuleApplier       := require './rule'       .PermitRuleApplier
    PermitRegistry    := require './registry'   .PermitRegistry
    UsePermitMatcher  := require './matcher'    .UsePermitMatcher
    PermitAllower     := require '../allower'   .PermitAllower

    Permit.registry ||= new PermitRegistry

    @registry!.register-permit @

    @rule-repo          = new RuleRepo @name
    @rule-applier       = new RuleApplier @, @debugging
    @use-permit-matcher = new UsePermitMatcher @, @access-request
    @permit-allower     = new PermitAllower @rule-repo
    @

  registry: ->
    @@registry

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

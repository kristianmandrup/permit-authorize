Debugger        = require '../util' .Debugger

var RuleRepo, PermitRuleApplier, PermitRegistry, PermitMatcher, PermitAllower

module.exports = class Permit implements Debugger
  # Registers a permit in the PermitRegistry by name
  # @name - String
  # @description -String

  (@name, @description = '', @debugging) ->
    RuleRepo          := require '../rule'      .repo.RuleRepo
    PermitRuleApplier := require './rule'       .PermitRuleApplier
    PermitRegistry    := require './registry'   .PermitRegistry
    PermitMatcher     := require './matcher'    .PermitMatchController
    PermitAllower     := require '../allower'   .PermitAllower

    Permit.registry ||= new PermitRegistry

    @registry!.register-permit @

    @rule-repo          = new RuleRepo @name
    @rule-applier       = new PermitRuleApplier @, @debugging
    @permit-matcher     = new PermitMatcher @, @access-request, @debugging
    @permit-allower     = new PermitAllower @rule-repo
    @

  registry: ->
    @@registry

  # get a named permit
  @get = (name) ->
    PermitRegistry.get name

  # applies static rules
  # pre-compiles static rules that match
  init: ->
    @debug 'permit init'
    @rule-applier.apply-rules 'static'
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

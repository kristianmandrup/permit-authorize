Debugger        = require '../util' .Debugger

PermitRegistry  = require './registry'   .PermitRegistry
PermitMatcher   = require './matcher'    .PermitMatchController
RuleRepo        = require '../rule'      .repo.RuleRepo
PermitApplier   = require './rule'       .PermitRuleApplier
Observable      = require '../mixin'     .Observable
Activation      = require '../mixin'     .Activation

module.exports = class Permit implements Activation, Observable, Debugger
  # Registers a permit in the PermitRegistry by name
  # @name - String
  # @description -String

  (@name, @description = '', @debugging) ->
    @match-enabled      = false
    @activate! if @activate and @auto-activate
    @_register!
    @init!
    @

  @registry ||= new PermitRegistry

  repo: ->
    @_repo ||= new RuleRepo @name

  applier: ->
    @_applier ||= new PermitApplier @, @debugging

  permit-matcher: (access-request) ->
    new PermitMatcher @, access-request, @debugging

  # default empty rules
  rules: ->

  _register: ->
    @debug 'register permit', @
    @registry!.register @

  _unregister: ->
    @registry!.unregister @

  # get a named permit
  @get = (name) ->
    @@registry.get name

  registry: ->
    @@registry

  @enable-match = ->
    @match-enabled = true

  @disable-match = ->
    @match-enabled = false

  # See if this permit should apply (be used) for the given access request
  # By default @match-enabled is undefined which means false ie. disabled
  match: (access-request)->
    @permit-matcher(access-request).match! if @match-enabled

  # applies static rules
  # pre-compiles static rules that match
  init: ->
    @debug 'permit init'
    @applier.apply 'static'
    @

  clean: ->
    @repo!.clean!
    @applier!.clean!

  can-rules: ->
    @repo!.can-rules!

  cannot-rules: ->
    @repo!.cannot-rules!


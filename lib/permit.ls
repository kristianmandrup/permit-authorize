requires  = require '../requires'
lo        = requires.util 'lodash-lite'

PermitRegistry  = requires.permit 'permit_registry'
PermitMatcher   = requires.permit 'permit_matcher'
PermitAllower   = requires.permit 'permit_allower'
RuleApplier     = requires.rule 'rule_applier'
RuleRepo        = requires.rule 'rule_repo'

matchers        = requires.lib 'matchers'

UserMatcher     = matchers.UserMatcher
SubjectMatcher  = matchers.SubjectMatcher
ActionMatcher   = matchers.ActionMatcher
ContextMatcher  = matchers.ContextMatcher
AccessMatcher   = matchers.AccessMatcher

Debugger        = requires.lib 'debugger'

module.exports = class Permit implements Debugger
  (@name, @description = '') ->
    PermitRegistry.register-permit @
    @rule-repo = new RuleRepo @name
    @applied-rules = false
    @

  permit-matcher-class: PermitMatcher
  rule-applier-class: RuleApplier

  # get a named permit
  @get = (name) ->
    PermitRegistry.get name

  init: ->
    @apply-rules!
    @

  clean: ->
    @rule-repo.clean!
    @applied-rules = false

  # used by permit-for to extend specific permit from base class (prototype)
  use: (obj) ->
    obj = obj! if typeof! obj is 'Function'
    if typeof! obj is 'Object'
      lo.extend @, obj
    else throw Error "Can only extend permit with an Object, was: #{typeof! obj}"

  # default empty rules
  rules: ->

  # Access allowance
  # ----------------

  permit-allower: ->
    new PermitAllower @rule-repo, @debugging

  allows: (access-request) ->
    @debug 'permit allows?', @name, @description
    res = @permit-allower!.allows access-request
    @debug "#{@name} Permit allows:", @rules, access-request, res
    res

  disallows: (access-request) ->
    @debug 'permit disallows?', @name, @description
    res = @permit-allower!.disallows access-request
    @debug "#{@name} Permit disallows:", @rules, access-request, res
    res


  # Permit matching
  # ----------------

  # TODO: should do clever caching via md5 hash?
  matching: (access) ->
    new AccessMatcher access

  matcher: (access-request) ->
    new @permit-matcher-class @, access-request, @debugging

  # See if this permit should apply (be used) for the given access request
  # TODO: improve using a declarative approach
  # matches-on:
  #   roles: ['editor', 'publisher']
  #   actions: ['edit', 'write', 'publish']

  matches: (access-request) ->
    @debug 'matches', access-request
    @matcher(access-request).match!

  match-user: (access-request, user) ->
    @matches(access-request).user user

  match-role: (access-request, role) ->
    @matches(access-request).role role

  match-subject: (access-request, subj) ->
    @matches(access-request).subject subj

  match-subject-clazz: (clazz) ->
    @matches(access-request).subject-clazz: clazz

  match-action: (action) ->
    @matches(access-request).action action

  match-context: (ctx) ->
    @matches(access-request).context ctx

  match-ctx: (ctx) ->
    @matches(access-request).ctx ctx

  # Rule Application
  # ----------------

  rule-applier: (access-request) ->
    access-request = {} unless typeof! access-request is 'Object'
    new @rule-applier-class @rule-repo, @rules, access-request, @debugging

  # always called (can be overridden for custom behavior)
  apply-rules: (access-request, force) ->
    unless access-request is undefined or typeof! access-request is 'Object'
      force = Boolean access-request
    unless @applied-rules and not force
      @debug 'permit apply rules', access-request
      @rule-applier(access-request).apply-rules!
      @applied-rules = true
    else
      @debug 'rules already applied before', @applied-rules

  can-rules: ->
    @rule-repo.can-rules

  cannot-rules: ->
    @rule-repo.cannot-rules

lo.extend Permit, Debugger
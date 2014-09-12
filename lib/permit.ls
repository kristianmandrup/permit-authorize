lo              = require './util/lodash_lite'
Debugger        = require './debugger'

PermitRegistry  = require './permit/permit_registry'
PermitMatcher   = require './permit/permit_matcher'
PermitAllower   = require './permit/permit_allower'
RuleApplier     = require './rule/rule_applier'
RuleRepo        = require './rule/rule_repo'

matchers        = require './matchers'

UserMatcher     = matchers.UserMatcher
SubjectMatcher  = matchers.SubjectMatcher
ActionMatcher   = matchers.ActionMatcher
ContextMatcher  = matchers.ContextMatcher
AccessMatcher   = matchers.AccessMatcher

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
    @debug 'permit init'
    @apply-rules!
    @configure-matchers!
    @

  configure-matchers: ->
    @debug "configure-matchers", @matches-on
    return unless typeof! @matches-on is 'Object'

    @compiled-list = []
    @debug "compile..."
    for key of @matches-on
      @compile-for key, @matches-on[key]
    @debug 'compiled matchers:', @compiled-list

  compile-for: (key, list) ->
    @debug "compile for", key, list
    fun = @compiled-matcher(key, list)
    @debug 'fun', fun
    @compiled-list.push fun

  compiled-matcher: (type, match-list) ->
    self = @
    (access-request) ->
      match-obj = {(type): match-list}
      self.debug 'compiled fun: match-on', access-request
      self.match-on access-request, match-obj

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
  matches: (access-request) ->
    @debug 'matches', access-request
    permit-matcher = @matcher(access-request)
    @debug 'permit matcher', permit-matcher
    permit-matcher.match!

  match-on: (access-request, match-obj) ->
    @matching(access-request).match-on match-obj

  match-user: (access-request, user) ->
    @matching(access-request).user user

  match-role: (access-request, role) ->
    @matching(access-request).role role

  match-subject: (access-request, subj) ->
    @matching(access-request).subject subj

  match-subject-clazz: (clazz) ->
    @matching(access-request).subject-clazz: clazz

  match-action: (action) ->
    @matching(access-request).action action

  match-context: (ctx) ->
    @matches(access-request).context ctx

  match-ctx: (ctx) ->
    @matching(access-request).ctx ctx

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
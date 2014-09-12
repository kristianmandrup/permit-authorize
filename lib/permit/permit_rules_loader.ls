lo        = require '../util/lodash_lite'
Debugger  = require '../debugger'
fs = require 'fs'

permit-for  = require '../permit/permit_for'

Array.prototype.contains = (v) ->
  @indexOf(v) > -1

class PermitRulesLoader implements Debugger
  (@file-path, @options = {}) ->
    @loaded-rules = {}
    @async = @options.async

  create-permit: (name, options = {}) ->
    base-clazz ||= options.clazz or requires.lib('permit')
    loaded-rules = @load-rules!.rules!
    console.log 'loaded-rules', loaded-rules, @file-path
    permit = permit-for base-clazz, name, (->
      rules: {}
    )
    if options.key then permit.rules[key] = loaded-rules else permit.rules = loaded-rules

  load-rules: (file-path, async) ->
    @file-path ||= file-path
    unless async is void then @async = async else @async ||= true
    @debug "loadRules", @file-path
    unless @file-path
      throw Error "Error: Missing filepath"

    if @async then @load-rules-async(file-path) else @load-rules-sync(file-path)

  load-rules-async: ->
    @debug 'loadRulesAsync'
    self = @
    fs.read-file @file-path, 'utf8', (err, data) ->
      self.debug err, data
      if err
        @debug err
        throw Error "Error loading file: #{@file-path} - #{err}"

      self.debug "data", data
      rules = JSON.parse data
      self.debug "loaded-rules", rules
      self.loaded-rules = rules
      self.process-rules!
    @

  load-rules-sync: ->
    try
      data = fs.read-file-sync @file-path, 'utf8' ->
      @debug "data", data
      unless typeof! data is 'String'
        throw Error
      rules = JSON.parse data
      @debug "loaded-rules", rules
      @loaded-rules = rules
      @process-rules!
      @
    catch err
      throw Error "Error loading file: #{@file-path} - #{err}"
 
  load-rules-from: (path) ->
    @load-rules path

  load: (path) ->
    @load-rules path

  process-rules: ->
    @debug "processRules", @loaded-rules
    throw Error "Rules not loaded or invalid: #{@loaded-rules}" unless typeof! @loaded-rules is 'Object'
 
    @processed-rules = {}
    for key, rule of @loaded-rules
      @process-rule key, rule
    
    @processed-rules

  process-rule: (key, rule) ->
    @debug "processRule", key, rule
    @processed-rules[key] = @rule-for rule

  create-rules-at: (permit, place) ->
    unless typeof! permit is 'Function'
      throw Error "Not a permit, was: #{permit}" 
      
    if place?
      unless permit.rules? and typeof! permit.rules is 'Object'
        throw Error "Permit has no rules object to place loaded rules at #{place}" 
      permit.rules[place] = @processed-rules
    else
      permit.rules = @processed-rules

  rules: ->
    @processed-rules

  rule-for: (rule) ->
    @debug "ruleFor", rule
    key = Object.keys(rule).0
    unless ['can', 'cannot'].contains(key)
      throw Error "Not a valid rule key, must be 'can' or 'cannot', was: #{key}"
    @factory key, rule[key]

  factory: (act, rule) ->
    rules = []
    for action, subject of rule
      fun = @resolve(act, action, subject)
      rules.push fun
    ->
      for rule in rules
        @rule!

  resolve: (act, action, subject) ->
    ->
      @["u#{act}"] action, subject

module.exports = PermitRulesLoader
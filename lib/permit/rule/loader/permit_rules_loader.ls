Debugger    = require '../../../util' .Debugger
permit-for  = require '../../factory' .permitFor

Array.prototype.contains = (v) ->
  @indexOf(v) > -1

RulesFileLoader = require './rules_file_loader'

module.exports = class PermitRulesLoader implements Debugger
  (@file-path, @options = {}) ->
    @loaded-rules = {}
    @file-loader = new RulesFileLoader @file-path, @loaded-rules-callback, @options

  load: (async) ->
    @file-loader.load-rules async

  loaded-rules-callback: (rules) ->
    @loaded-rules = rules
    @process-rules!

  create-permit: (name, options = {}) ->
    base-clazz ||= options.clazz or requires.lib('permit')
    loaded-rules = @load-rules!.rules!
    # console.log 'loaded-rules', loaded-rules, @file-path
    permit = permit-for base-clazz, name, (->
      rules: {}
    )
    if options.key then permit.rules[key] = loaded-rules else permit.rules = loaded-rules

  process-rules: ->
    @debug "processRules", @loaded-rules
    throw Error "Rules not loaded or invalid: #{@loaded-rules}" unless typeof! @loaded-rules is 'Object'
 
    @processed-rules = {}
    for key, rule of @loaded-rules
      @process-rule key, rule
    
    @processed-rules

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


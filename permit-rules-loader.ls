class PermitRulesLoader
  (@file-path) ->
 
  load-rules-file: (file-path) -> 
    fs = require 'fs'
    file-path ||= @file-path
    throw Error "Error: Missing filepath" unless file-path?
 
    fs.read-file file-path, 'utf8', (err, data) ->
      if err
        throw Error "Error loading file: #{file-path} - #{err}" 
     
      @loaded-rules = JSON.parse(data);
      process-rules!
 
  load-rules: (path) ->
    @load-rules-file path
 
  process-rules: ->
    throw Error "Rules not loaded" unless @loaded-rules?
 
    @processed-rules = {}
    self = @
    lo.each @loaded-rules, (key, rule) ->
      rules[key] = self.rule-for rule
    
    @processed-rules
 
  create-rules-at: (permit, place) ->
    unless typeof! permitis 'Function'
      throw Error "Not a permit, was: #{permit}" 
      
    if place?
      unless permit.rules? and typeof! permit.rules is 'Object'
        throw Error "Permit has no rules object to place loaded rules at #{place}" 
      permit.rules[place] = @processed-rules
    else
      permit.rules = @processed-rules
 
  rule-for: (rule) ->
    key = lo.keys(rule).0
    unless ['can', 'cannot'].include key
      throw Error "Not a valid rule key, must be 'can' or 'cannot', was: #{key}"
    
    @["#{key}-factory"] rule[key]
 
  can-factory: (action, subject) ->
    ->
      @ucan action, subject
 
  cannot-factory: (action, subject) ->
    ->
      @ucannot action, subject
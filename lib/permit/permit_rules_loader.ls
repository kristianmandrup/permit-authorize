lo = requires.util 'lodash-lite'
fs = require 'fs'

class PermitRulesLoader
  (@file-path) ->
 
  load-rules-file: (file-path) ->
    file-path ||= @file-path
    throw Error "Error: Missing filepath" unless file-path?
 
    fs.read-file file-path, 'utf8', (err, data) ->
      throw new Error "Error loading file: #{file-path} - #{err}" if err
      @loaded-rules = JSON.parse data
      process-rules!
 
  load-rules: (path) ->
    @load-rules-file path
 
  process-rules: ->
    throw new Error "Rules not loaded" unless @loaded-rules?
 
    @processed-rules = {}
    self = @
    for each key, rule of @loaded-rules
      @process-rule key, rule
    
    @processed-rules

  process-rule: (key, rule) ->
    @processed-rules[key] = @rule-for rule

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
    key = Object.keys(rule).0
    unless ['can', 'cannot'].include key
      throw Error "Not a valid rule key, must be 'can' or 'cannot', was: #{key}"
    
    @factory-for(key) rule[key]

  factory-for: (key) ->
    @["#{key}Factory"]

  can-factory: (action, subject) ->
    ->
      @ucan action, subject
 
  cannot-factory: (action, subject) ->
    ->
      @ucannot action, subject

modules.export = PermitRulesLoader
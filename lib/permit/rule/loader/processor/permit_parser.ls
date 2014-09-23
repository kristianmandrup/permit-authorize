RuleMatchesProcessor  = require './rule_matches_processor'
RulesProcessor        = require './rules_processor'

module.exports = class PermitParser
  (@obj) ->

  matches-clazz: RuleMatchesProcessor
  rules-clazz: RulesProcessor

  parse-matches: ->
    new @matches-clazz(@obj).process!

  parse-rules: ->
    new @rules-clazz(@obj).process!

  try-parse-rules: ->
    try
      @parse-rules!
    catch
      @parse-rule!

  parse-rule: ->
    new @rules-clazz(@obj).process!

  parse: ->
    @parsed-permit = @parse-matches! <<< @try-parse-rules!




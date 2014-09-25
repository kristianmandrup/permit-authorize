module.exports = class ActRuleProcessor
  (@act, @rule) ->
    @rules = []

  process: ->
    for action, subject of @rule
      fun = @resolve(@act, action, subject)
      @rules.push fun
    ->
      for rule in @rules
        rule!

  resolve: (act, action, subject) ->
    ->
      @["u#{act}"] action, subject
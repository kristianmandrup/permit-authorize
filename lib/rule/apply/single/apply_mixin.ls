module.exports =
  context-rules: (name)->
    @debug 'context rules', name
    return name if typeof! name is 'Object'
    return @rules unless typeof! name is 'String'

    return @rules[name] if typeof! @rules[name] is 'Object'
    @rules

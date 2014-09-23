module.exports = ->
  count-props = (obj) ->
    count = 0
    for k in obj
      count++ if (obj.has-own-property(k))
    count;

  object-equals = (v1, v2) ->
    return false if typeof(v1) is not typeof(v2)
    if typeof! v1 is 'Object' and typeof! v2 is 'Object'
      return false if count-props(v1) isnt count-props(v2)
      r = true
      for k in v1
        r = object-equals v1[k], v2[k]
        return false unless r
      return true
    else
      return v1 is v2

  recursive-partial-equal = (partial-obj, compare-obj) ->
    res = {}
    return false if partial-obj is void or compare-obj is void

    for key of partial-obj
      res[key] = false
      partial = partial-obj[key]
      compare = compare-obj[key]
      continue if partial is void

      if typeof! partial is 'Object' and typeof! compare is 'Object'
        equals = recursive-partial-equal partial, compare if compare?
      else
        equals = object-equals partial, compare

      res[key] = true if equals

    for key of partial-obj
      unless res[key]
        return false
    true

  on: (partial, obj) ->
    recursive-partial-equal partial, obj

module.exports = ->
  countProps = (obj) ->
    count = 0
    for k in obj
      count++ if (obj.hasOwnProperty(k))
    count;

  objectEquals = (v1, v2) ->
    return false if typeof(v1) is not typeof(v2)
    if v1 instanceof Object && v2 instanceof Object
      return false if countProps(v1) isnt countProps(v2)
      r = true
      for k in v1
        r = objectEquals v1[k], v2[k]
        return false unless r
      return true
    else
      return v1 is v2

  recursivePartialEqual = (partialObj, compareObj) ->
    res = {}
    return false unless partialObj? and compareObj?
    return false if typeof! partialObj is 'Unknown' or typeof! compareObj is 'Unknown'

    for key in _.keys partialObj
      res[key] = false
      partial = partialObj[key]
      compare = compareObj[key]
      continue if partial is 'undefined'

      if partial instanceof Object && compare instanceof Object
        equals = recursivePartialEqual partial, compare if compare?
      else
        equals = objectEquals partial, compare

      res[key] = true if equals

    for key in _.keys partialObj
      unless res[key]
        return false
    true

  on: (partial, obj) ->
    recursivePartialEqual partial, obj

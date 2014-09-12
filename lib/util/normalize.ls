lo = require './lodash_lite'

flatten = (items, res) ->
  res = [] if not res
  return items if typeof! items is 'String'
  for item in items
    if typeof! item is 'Array'
      flatten item, res
    else
      res.push item
  res

normalize = (items, recursed) ->
  normalized = switch typeof! items
  when 'Function'
    normalize items!, true
  when 'String'
    if recursed then items else [items]
  when 'Array'
    lo.map items, (item) ->
      normalize item, true
  else
    throw Error "#{items} #{typeof! items} can't be normalized, must be a Function, String or Array"
  flatten normalized

module.exports = normalize
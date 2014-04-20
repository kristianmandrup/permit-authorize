_ = require 'prelude-ls'

flatten = (items, res) ->
  res = [] if not res
  return items if typeof! items == 'String'
  for item in items
    if typeof! item == 'Array'
      flatten item, res
    else
      res.push item
  res

normalize = (items, recursed) ->
  normalized = switch typeof! items
  when 'Function'
    normalize items(), true
  when 'String'
    if recursed then items else [items]
  when 'Array'
    items.map(
      (item) -> normalize item, true
    )
  else
    throw Error "#{items} #{typeof! items} can't be normalized, must be a Function, String or Array"
  flatten(normalized)

module.exports = normalize
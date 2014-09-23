module.exports =
  recurse: (val, ctx) ->
    switch typeof! val
    when 'Function'
      val.call ctx
    when 'Object'
      for k of val
        recurse k, ctx

  valid-rules: (rules)->
    typeof! rules is 'Object' or typeof! rules is 'Function'

recurse = (val, ctx, access-request) ->
    switch typeof! val
    when 'Function'
      val.call ctx, access-request
    when 'Object'
      for k of val
        recurse k, ctx, access-request


module.exports =
  recurse: recurse

  valid-rules: (rules)->
    typeof! rules is 'Object' or typeof! rules is 'Function'

module.exports =
  camel-case: (s) ->
    (s or '').to-lower-case!.replace /(\b|-)\w/g, (m) ->
      m.to-upper-case!.replace /-/, ''

module.exports =  ->
    # for JSON fingerprint
    sort_object: (map) ->
        keys = _.sortBy(_.keys(map), (a) -> a)
    newmap = {}
    _.each(keys, (k) ->
        newmap[k] = map[k]
    )
    newmap

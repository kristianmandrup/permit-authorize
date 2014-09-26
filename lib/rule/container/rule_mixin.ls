
module.exports =
  container-for: (act) ->
    @valid-container @container[act], act

  valid-container: (container, act) ->
    return container if typeof! container is 'Object'
    throw Error "No valid rule container for #{act} in #{container}"

  manage-actions: ['create', 'edit', 'delete']
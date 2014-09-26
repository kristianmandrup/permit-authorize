
module.exports =
  container-for: (act) ->
    @act-container-for act.to-lower-case!

  act-container-for: (act) ->
    @valid-container @container[act], act

  valid-container: (container, act) ->
    return container if typeof! container is 'Object'
    throw Error "No valid rule container for: #{act}, was: #{container}"

  manage-actions: ['create', 'edit', 'delete']
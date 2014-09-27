module.exports =
  observers: []

  addObserver: (observer) ->
    observers.push observer

  notify: (event) ->
    for observer in observers
      observer.notify event, @ if typeof! observer?notify is 'Function'

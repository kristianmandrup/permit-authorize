module.exports =
  observers: []

  addObserver: (observer) ->
    @observers.push observer

  notify: (event) ->
    for observer in @observers
      observer.receive event, @ if typeof! observer?receive is 'Function'

lo = requires.util 'lodash-lite'

module.exports = class Book
  (@obj) ->
    if typeof! @obj is 'Object'
      for key in Object.keys @obj
        @[key] = @obj[key]

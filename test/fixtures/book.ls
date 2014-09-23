module.exports = class Book
  (@obj) ->
    if typeof! @obj is 'Object'
      for key of @obj
        @[key] = @obj[key]

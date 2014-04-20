_ = require 'prelude-ls'


module.exports = class Book
  (@obj) ->
    if _.is-type 'Object', @obj
      for key in _.keys(@obj)
        @[key] = @obj[key]

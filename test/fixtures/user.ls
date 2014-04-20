_ = require 'prelude-ls'

module.exports = class User
  (user) ->
    @set user

  set: (user)->
    for key in _.keys(user)
      @[key] = user[key]

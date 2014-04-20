lo = require 'lodash'

module.exports = class User
  (user) ->
    @set user

  set: (user)->
    for key in lo.keys user
      @[key] = user[key]

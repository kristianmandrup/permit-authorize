lo = requires.util 'lodash-lite'

module.exports = class User
  (user) ->
    @set user

  set: (user)->
    for key in Object.keys user
      @[key] = user[key]

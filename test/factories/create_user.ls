requires  = require '../../requires'
User      = requires.fix 'user'

create-user =
  name: (name)->
    new User name: name, clazz: 'User'

  kris: ->
    @name 'kris'

  javier: ->
    @name 'javier'

  emily: ->
    @name 'emily'

  role: (role) ->
    new User name: 'kris', role: role

  guest: ->
    @role 'guest'

  admin: ->
    @role 'admin'

  auth: ->
    @role 'auth'

  name-role: (name, role) ->
    new User name: name, role: role

module.exports = create-user
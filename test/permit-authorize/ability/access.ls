requires = require '../../../requires'

obj = requires.util 'obj_util'

create-user     = requires.fac 'create-permit'
create-request  = requires.fac 'create-request'

module.exports =
    empty  : {}

    user   : (user) ->
      create-request.user-access user

    role   : (role) ->
      create-request.role-access 'admin'

    guest  : ->
      @role 'guest'
    admin  : ->
      @role 'admin'

    kris   :
      user:
        name: 'kris'
      action: 'read'
      ctx:
        auth: true

    kris-admin   : ({} <<< @admin) <<< @kris

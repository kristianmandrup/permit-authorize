requires = require '../../../requires'

Ability       = requires.lib 'ability'
create-user   = requires.fac 'create-user'

ability = (user) ->
  new Ability user

module.exports =
  kris  : ability create-user.kris!
  guest : ability create-user.guest!
  admin : ability create-user.admin!

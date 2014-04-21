requires = require '../../../requires'

CachedAbility = requires.ability 'cached-ability'
create-user   = requires.fac 'create-user'

ability = (user) ->
  new CachedAbility user

module.exports =
  kris  : ability create-user.kris!
  guest : ability create-user.guest!
  admin : ability create-user.admin!

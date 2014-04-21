requires = require '../../../requires'

CachedAbility = requires.lib 'cached_ability'
create-user   = requires.fac 'create-user'

ability = (user) ->
  new CachedAbility user

module.exports =
  kris  : ability create-user.kris!
  guest : ability create-user.guest!
  admin : ability create-user.admin!

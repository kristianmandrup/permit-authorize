requires  = require './requires'

module.exports =
  Authorizer:    requires.lib 'authorizer'
  Ability:       requires.lib 'ability'
  Allower:       requires.lib 'allower'
  CachedAbility: requires.lib 'cached_ability'
  Permit:        requires.lib 'permit'
  permit-for:    requires.permit 'permit-for'

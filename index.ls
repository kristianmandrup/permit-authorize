requires  = require './requires'

module.exports =
  Authorizer:    requires.lib 'authorizer'
  Ability:       requires.lib 'ability'
  Allower:       requires.lib 'allower'
  CachedAbility: requires.ability 'cached_ability'
  Permit:        requires.lib 'permit'
  # RulesLoader:   requires.permit 'permit-rules-loader'
  permit-for:    requires.permit 'permit-for'

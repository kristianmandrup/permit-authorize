requires  = require './requires'

module.exports =
  Authorizer:    requires.lib 'authorizer'
  Ability:       requires.lib 'ability'
  Allower:       requires.lib 'allower'
  CachedAbility: requires.ability 'cached_ability'
  Permit:        requires.lib 'permit'
  RulesLoader:   requires.permit 'permit_rules_loader'
  DbRulesLoader: requires.permit 'permit_rules_db_loader'
  permit-for:    requires.permit 'permit-for'

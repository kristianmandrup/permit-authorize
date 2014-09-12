module.exports =
  Authorizer:    require './lib/authorizer'
  Ability:       require './lib/ability'
  Allower:       require './lib/allower'
  CachedAbility: require './lib/ability/cached_ability'
  Permit:        require './lib/permit'
  RulesLoader:   require './lib/permit/permit_rules_loader'
  DbRulesLoader: require './lib/permit/permit_rules_db_loader'
  permit-for:    require './lib/permit/permit_for'

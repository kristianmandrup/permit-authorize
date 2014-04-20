requires  = require './requires'

module.exports =
  Authorizer :   requires.lib 'authorizer'
  Ability :      requires.lib 'ability'
  Allower :      requires.lib 'allower'
  Permit :       requires.lib 'permit'
  permit-for:    requires.permit 'permit-for'

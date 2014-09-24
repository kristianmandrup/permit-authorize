# TODO: Yeah!

requires  = require '../../../../requires'

requires.test 'test_setup'

Permit          = requires.lib 'permit' .Permit
RuleRepo        = requires.rule 'repo' .RuleRepo

# RuleApplier     = requires.rule 'rule_applier'

PermitMatcher   = requires.permit 'matcher' .UsePermitMatcher
PermitAllower   = requires.lib 'allower' .PermitAllower
permit-for      = requires.permit 'factory' .permitFor

Book            = requires.fix  'book'

describe 'Permit' ->
  permits = {}

  before ->
    permits.hello := new Permit 'hello'

  describe 'use' ->
    context 'single permit named hello' ->
      specify 'using Object adds object to permit' ->
        permits.hello.use {state: 'on'}

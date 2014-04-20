requires        = require '../../../requires'

requires.test 'test_setup'

Permit          = requires.lib 'permit'
PermitRegistry  = requires.permit 'permit-registry'
PermitMatcher   = requires.permit 'permit_matcher'
PermitAllower   = requires.permit 'permit_allower'
permit-for      = requires.permit 'permit_for'

RuleRepo        = requires.rule 'rule_repo'
RuleApplier     = requires.rule 'rule_applier'

Book            = requires.fix 'book'
permit-clazz    = requires.fix 'permit-class'

create-permit   = requires.fac 'create-permit'

AdminPermit     = permit-clazz.AdminPermit
GuestPermit     = permit-clazz.GuestPermit

describe 'Permit' ->
  requests = {}
  permits  = {}

  before ->
    permits.empty   := new Permit

  after ->
    PermitRegistry.clear-all!

  describe 'init creates a permit ' ->
    specify 'first unnamed permit is named Permit-0' ->
      permits.empty.name.should.eql 'Permit-0'

    specify 'with no description' ->
      permits.empty.description.should.eql ''

  context 'extra Guest permit' ->
    before ->
      permits.guest    := new GuestPermit

    specify 'second unnamed is named Permit-1' ->
      permits.guest.name.should.eql 'Permit-1'


  context 'a single permit named hello' ->
    before ->
      permits.hello := new Permit 'hello'

    # clean up
    after ->
      PermitRegistry.clear-all!

    specify 'first unnamed permit is named Permit-0' ->
      permits.hello.name.should.eql 'hello'

    describe 'rules' ->
      specify 'has an empty canRules list' ->
        permits.hello.can-rules!.should.be.empty

      specify 'has an empty cannotRules list' ->
        permits.hello.cannot-rules!.should.be.empty

    describe 'rule-applier-class' ->
      specify 'by default has rule-applier-class = RuleApplier' ->
        permits.hello.rule-applier-class.should.eql RuleApplier

    describe 'permit-allower' ->
      specify 'has an allower' ->
        permits.hello.permit-allower!.constructor.should.eql PermitAllower

    describe 'permit-matcher-class' ->
      specify 'permit by default has permit-matcher-class = PermitMatcher' ->
        permits.hello.permit-matcher-class.should.eql PermitMatcher

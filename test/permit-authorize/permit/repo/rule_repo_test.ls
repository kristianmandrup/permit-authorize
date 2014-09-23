requires        = require '../../../requires'

requires.test 'test_setup'

Permit            = requires.lib 'permit'
PermitRegistry    = requires.permit 'permit-registry'
RuleRepo          = requires.rule 'rule_repo'

describe 'Permit' ->
  permits = {}

  describe 'rule-repo' ->
    before-each ->
      permits.empty := new Permit

    # clean up!
    after-each ->
      PermitRegistry.clear-all!

    specify 'has a rule-repo' ->
      permits.empty.rule-repo.constructor.should.eql RuleRepo

    specify 'has same name as permit' ->
      permits.empty.rule-repo.name.should.eql permits.empty.name

    specify 'has empty can-rules' ->
      permits.empty.rule-repo.can-rules.should.eql {}

    specify 'has empty cannot-rules' ->
      permits.empty.rule-repo.can-rules.should.eql {}

  describe 'can rules' ->
    specify 'are empty' ->
      permits.empty.can-rules!.should.be.empty

    specify 'same as repo rules' ->
      permits.empty.can-rules!.should.be.eql permits.empty.rule-repo.can-rules

  describe 'cannot rules' ->
    specify 'are empty' ->
      permits.empty.cannot-rules!.should.be.empty

    specify 'same as repo rules' ->
      permits.empty.cannot-rules!.should.be.eql permits.empty.rule-repo.cannot-rules

requires  = require '../../../../requires'

requires.test 'test_setup'

RuleRepo        = requires.rule 'repo' .RuleRepo

PermitRegistry  = requires.permit 'registry' .PermitRegistry
Permit          = requires.permit 'permit'

create-permit   = requires.fac  'create-permit'

describe 'PermitRegistry' ->
  permits = {}

  describe 'create instance' ->
    specify 'should not throw error' ->
      ( -> new PermitRegistry ).should.not.throw

  registry = ->
    new PermitRegistry

  context 'an instance' ->
    var reg
    before ->
      reg := registry!

    describe 'initial state' ->
      describe 'permits' ->
        specify 'should be empty' ->
          reg.permits.should.eql {}

      describe 'permit-count' ->
        specify 'should be 0' ->
          reg.permit-count!.should.eql 0

    describe 'create a permit' ->
      before ->
        permits.guest = create-permit.guest!
        reg := Permit.registry

      describe 'permits' ->
        specify 'should have guest permit' ->
          reg.permits['guest books'].should.eql permits.guest

      describe 'permit-count' ->
        specify 'should be 1' ->
          reg.permit-count!.should.eql 1


    context 'guest permit' ->
      before ->
        reg := Permit.registry
        reg.clean!
        permits.guest = create-permit.guest!


      describe 'clean-all' ->
        context 'cleaned permits' ->
          counters = {}
          repos = {}

          before ->
            reg.clean!
            permits.guest = create-permit.guest!

            counters.old  := reg.permit-count!
            permits.old   := reg.permits
            repos.old     := permits.guest.rule-repo

            permits.guest.debug-on!

            reg.clean!

          specify 'old repo is a RuleRepo' ->
            repos.old.constructor.should.eql RuleRepo

          describe 'permit-counter' ->
            specify 'should not change' ->
              reg.permit-count!.should.eql counters.old

          describe 'permits' ->
            specify 'should not change' ->
              reg.permits.should.eql permits.old

          describe 'repo' ->
            describe 'should be cleaned' ->
              var cleaned-permit

              before ->
                cleaned-permit := reg.permits['guest books']

              specify 'repo is same instance' ->
                cleaned-permit.rule-repo.should.eql repos.old

              specify 'repo can-rules are empty' ->
                cleaned-permit.rule-repo.can-rules.should.eql {}

              specify 'repo cannot-rules are empty' ->
                cleaned-permit.rule-repo.cannot-rules.should.eql {}

              specify 'can-rules are empty' ->
                cleaned-permit.can-rules!.should.eql {}

              specify 'cannot-rules are empty' ->
                cleaned-permit.cannot-rules!.should.eql {}

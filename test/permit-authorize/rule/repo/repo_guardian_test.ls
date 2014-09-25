requires  = require '../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

PermitAllower = requires.lib 'allower' .PermitAllower

RepoGuardian  = requires.lib + 'rule/repo/' .RepoGuardian
RuleRepo      = requires.lib + 'rule/repo/' .RuleRepo

expect = require 'chai' .expect

rule-repo = (name) ->
  new RuleRepo name

describe 'RepoGuardian' ->
  describe 'create with null' ->
    specify 'should throw' ->
      expect(-> new RepoGuardian).to.throw

  describe 'create with repo' ->
    specify 'should not throw' ->
      expect(-> new RepoGuardian {}).to.not.throw

  context 'created with repo' ->
    var guardian
    var ar

    repos =
      access: rule-repo 'access'
      no-access: rule-repo 'no-access'

    describe 'permit-allower' ->
      before ->
        guardian = new RepoGuardian repo

      specify 'should create and return' ->
        guardian.permit-allower!.should.be.instanceOf PermitAllower

    context 'repo does not allow access' ->
      before ->
        guardian = new RepoGuardian repos.no-access

      describe 'allows' ->
        specify 'should not allow' ->
          guardian.allows(ar).should.be.false

      describe 'disallows' ->
        specify 'should disallow' ->
          guardian.disallows(ar).should.be.true

    context 'repo does allow access' ->
      before ->
        guardian = new RepoGuardian repos.access

      describe 'allows' ->
        specify 'should allow' ->
          guardian.allows(ar).should.be.true

      describe 'disallows' ->
        specify 'should not disallow' ->
          guardian.disallows(ar).should.be.false

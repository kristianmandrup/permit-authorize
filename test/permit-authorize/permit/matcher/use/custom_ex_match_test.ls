requires        = require '../../../../../requires'

requires.test 'test_setup'

Book            = requires.fix 'book'
User            = requires.fix 'user'

Permit          = requires.lib 'permit'
permit-for      = requires.permit 'factory' .permitFor
PermitMatcher   = requires.permit 'matcher' .UsePermitMatcher
PermitRegistry  = requires.permit 'registry' .PermitRegistry

setup           = requires.fix 'permits' .setup

create-user     = requires.fac 'create-user'
create-request  = requires.fac 'create-request'
create-permit   = requires.fac 'create-permit'

describe 'PermitMatcher' ->
  var subject
  var permit-matcher, book

  users     = {}
  permits   = {}
  requests  = {}

  matching = {}
  none-matching = {}

  describe 'custom-ex-match' ->
    before ->
      PermitRegistry.clear-all!

      requests.admin :=
        user: {role: 'admin'}

      requests.ctx :=
        ctx: void

      permits.ex-user := setup.ex-user-permit!

      # should match since the ex-user-permit has an ex-match method that matches on has-role 'admin'
      matching.permit-matcher       := new PermitMatcher permits.ex-user, requests.admin

      none-matching.permit-matcher  := new PermitMatcher permits.ex-user, requests.ctx

    specify 'matches access-request using permit.ex-match' ->
      matching.permit-matcher.custom-ex-match!.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.permit-matcher.custom-ex-match!.should.be.false

    describe 'invalid ex-match method' ->
      before ->
        permits.invalid-ex-user := setup.invalid-ex-user!

      specify 'should throw error' ->
        ( -> none-matching.permit-matcher.custom-ex-match ).should.throw
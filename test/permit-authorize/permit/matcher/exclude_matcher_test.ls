requires        = require '../../../../requires'

requires.test 'test_setup'

Matcher         = requires.permit 'matcher' .ContextMatcher
Permit          = requires.lib 'permit'     .Permit

setup           = requires.fix 'permits'    .setup

create-user     = requires.fac 'create-user'

create-matcher = (ctx, ar, debug = true) ->
  new Matcher ctx, ar, debug


describe 'PermitMatcher' ->
  var matcher, book

  users     = {}
  permits   = {}
  requests  = {}

  matching = {}
  none-matching = {}

  before ->
    users.kris    := create-user.kris!
    users.emily   := create-user.emily!
    requests.user :=
      user: users.kris

    permits.user   := setup.user-permit!

  describe 'exclude' ->
    describe 'excludes user.name: kris' ->
      before-each ->
        permits.user.excludes =
          user: users.kris

        matcher := create-matcher permits.user, requests.user

      specify 'matches access-request on excludes intersect' ->
        matcher.exclude!.should.be.true

    describe 'excludes empty {}' ->
      before-each ->
        permits.user.excludes = {}
        matcher := create-matcher permits.user, requests.user

      specify 'matches access-request since empty excludes always intersect' ->
        matcher.exclude!.should.be.true

    describe 'excludes other user' ->
      before-each ->
        permits.user.excludes =
          user: users.emily
        matcher := create-matcher permits.user, requests.user

      specify 'does NOT match access-request since NO excludes intersect' ->
        matcher.exclude!.should.be.false

  xdescribe 'custom-ex-match' ->
    var subject
    var matcher, book

    users     = {}
    permits   = {}
    requests  = {}

    matching = {}
    none-matching = {}

    requests.admin :=
      user: {role: 'admin'}

    requests.ctx :=
      ctx: void

    before-each ->
      Permit.registry.clear-all!

      permits.ex-user := setup.ex-user-permit!

      # should match since the ex-user-permit has an ex-match method that matches on has-role 'admin'
      matching.matcher       := create-matcher permits.user, requests.admin
      none-matching.matcher  := create-matcher permits.ex-user, requests.ctx

    specify 'matches access-request using permit.ex-match' ->
      matching.matcher.match!.should.be.true

    specify 'does NOT match access-request since permit.match does NOT match' ->
      none-matching.matcher.match!.should.be.false

    describe 'invalid ex-match method' ->
      before ->
        permits.invalid-ex-user := setup.invalid-ex-user!

      specify 'should throw error' ->
        ( -> none-matching.matcher.custom-ex-match ).should.throw
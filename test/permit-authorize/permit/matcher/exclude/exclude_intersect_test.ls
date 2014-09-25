requires        = require '../../../../../requires'

requires.test 'test_setup'

Matcher         = requires.permit 'matcher' .ContextMatcher
Permit          = requires.lib 'permit'     .Permit

setup           = requires.fix 'permits'    .setup

create-user     = requires.fac 'create-user'

create-matcher = (ctx, ar, debug = true) ->
  new Matcher ctx, ar, debug

intersect = (obj) ->
  {intersect: obj}

excludes = (obj) ->
  intersect {includes: obj}


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


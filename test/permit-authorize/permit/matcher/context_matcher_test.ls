requires  = require '../../../../requires'

requires.test 'test_setup'

ContextMatcher = requires.permit 'matcher' .ContextMatcher

create-user     = requires.fac 'create-user'

describe 'ContextMatcher' ->
  var permit-matcher, ctx, matcher

  users     = {}
  permits   = {}
  requests  = {}

  matching = {}
  none-matching = {}

  before ->
    users.kris   := create-user.kris
    users.emily  := create-user.emily

    requests.ctx :=
      ctx:
        area: 'guest'

    requests.user     :=
      user: users.kris
      name: 'hello'

    requests.user-and-more     :=
      user: users.kris
      name: 'hello'
      area: 'admin'

    requests.user-and-less     :=
      user: users.kris

    create-matcher = (ctx) ->
      new ContextMatcher ctx

    matcher          := create-matcher requests.user

  describe 'init' ->
    specify 'has context' ->
      matcher.context.should.eql requests.user

  describe 'match' ->
    specify 'by default always returns false' ->
      matcher.match!.should.be.false

  describe 'intersect-on partial, access-request' ->
    specify 'intersects when same object' ->
      matcher.intersect-on(requests.user).should.be.true

    specify 'intersects when more than context (covers)' ->
      matcher.intersect-on(requests.user-and-more).should.be.true

    specify 'does not intersects when less than context' ->
      matcher.intersect-on(requests.user-and-less).should.be.false

    specify 'does not intersects when other object' ->
      matcher.intersect-on(requests.ctx).should.be.false








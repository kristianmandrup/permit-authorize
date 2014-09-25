requires  = require '../../../../requires'

requires.test 'test_setup'

ContextMatcher = requires.permit 'matcher' .ContextMatcher

create-user     = requires.fac 'create-user'

describe 'ContextMatcher (intersect - default include)' ->
  var permit-matcher, ctx, key, matcher

  users     = {}
  permits   = {}
  requests  = {}
  ctx       = {}

  matching = {}
  none-matching = {}

  intersect = (obj) ->
    {intersect: obj}

  before ->
    users.kris   := create-user.kris
    users.emily  := create-user.emily

    ctx.base :=
      ctx:
        area: 'guest'
        secret: '123'

    ctx.and-more :=
      ctx:
        area: 'guest'
        secret: '123'
        more: 'So much more...'

    ctx.and-less :=
      ctx:
        area: 'guest'

    requests.user     :=
      user: users.kris

    requests.user-and-more     :=
      user: users.kris
      area: 'admin'

    requests.user-and-less     :=
      user: users.kris

    create-matcher = (ctx, key, access, debug = false) ->
      new ContextMatcher ctx, key, access, debug

    key := 'includes'

    matcher := create-matcher intersect(ctx.base), key, requests.user

  describe 'init' ->
    specify 'has context' ->
      matcher.context.should.eql intersect(ctx.base)

    specify 'has key' ->
      matcher.key.should.eql key

    specify 'has access-request' ->
      matcher.access-request.should.eql requests.user

  describe 'match' ->
    specify 'by default always returns false' ->
      matcher.match!.should.be.false

  describe 'intersect-on partial, access-request' ->
    specify 'intersects when same object' ->
      matcher.intersect-on(ctx.base).should.be.true

    specify 'intersects when more than context (covers)' ->
      matcher.intersect-on(ctx.and-more).should.be.true

    specify 'does not intersects when less than context' ->
      matcher.intersect-on(ctx.and-less).should.be.false

    specify 'does not intersects when other object' ->
      matcher.intersect-on(requests.user).should.be.false








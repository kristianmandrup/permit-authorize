requires  = require '../../requires'

requires.test 'test_setup'

Book          = requires.fix 'book'
User          = requires.fix 'user'

permit-for    = requires.permit 'permit_for'
PermitMatcher = requires.permit 'permit_matcher'
Permit        = requires.lib 'permit'

setup         = require('./permit_matcher/permits').setup

create-user     = requires.fac 'create-user'
create-request  = requires.fac 'create-request'
create-permit   = requires.fac 'create-permit'

describe 'PermitMatcher' ->
  var permit-matcher, book

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

    permits.user     := setup.user-permit
    permit-matcher    := new PermitMatcher permits.user, requests.user

  describe 'init' ->
    specify 'has user-permit' ->
      permit-matcher.permit.should.eql permits.user

    specify 'has own intersect object' ->
      permit-matcher.intersect.should.have.property 'on'

  describe 'intersect-on partial, access-request' ->
    specify 'intersects when same object' ->
      permit-matcher.intersect-on(requests.user).should.be.true








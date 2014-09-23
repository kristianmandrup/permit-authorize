requires        = require '../../../requires'

requires.test 'test_setup'

User            = requires.fix 'user'
matchers        = requires.lib 'access_request/matchers'

UserMatcher   = matchers.UserMatcher

describe 'UserMatcher' ->
  var user-matcher  

  users     = {}
  requests  = {}

  before ->
    users.admin := new User name: 'kris' role: 'admin'
    requests.admin :=
      user: users.admin

  describe 'create' ->
    before ->
      user-matcher  := new UserMatcher requests.admin

    specify 'must be a user matcher' ->
      user-matcher.should.be.an.instance-of UserMatcher

    specify 'must have admin access request' ->
      user-matcher.access-request.should.eql requests.admin

  describe 'match' ->
    before-each ->
      user-matcher  := new UserMatcher requests.admin

    specify 'should match admin role' ->
      user-matcher.match(role : 'admin').should.be.true

    specify 'should NOT match guest role' ->
      user-matcher.match(role: 'guest').should.be.false

    specify 'should match on no argument' ->
      user-matcher.match!.should.be.true

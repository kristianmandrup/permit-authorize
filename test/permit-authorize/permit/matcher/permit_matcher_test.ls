requires        = require '../../../../requires'

requires.test 'test_setup'

Book            = requires.fix 'book'
User            = requires.fix 'user'

Permit          = requires.lib 'permit'       .Permit
permit-for      = requires.permit 'factory'   .permitFor
PermitMatcher   = requires.permit 'matcher'   .PermitMatcher
PermitRegistry  = requires.permit 'registry'  .PermitRegistry

setup           = requires.fix 'permits' .setup

create-user     = requires.fac 'create-user'
create-request  = requires.fac 'create-request'
create-permit   = requires.fac 'create-permit'

create-matcher = (ctx, ar, debug = true) ->
  new PermitMatcher ctx, ar, debug

describe 'PermitMatcher' ->
  var permit-matcher, book

  users     = {}
  permits   = {}
  requests  = {}

  matching = {}
  none-matching = {}

  before ->
    users.kris    := create-user.kris
    users.emily   := create-user.name 'emily'

    requests.user  := create-request

    permits.user  := setup.user-permit!

    permit-matcher := create-matcher permits.user, requests.user

  describe 'match access' ->
    matching = {}
    none-matching = {}

    before ->
      requests.user :=
        user: {}
      requests.ctx :=
        ctx: ''

      matching.permit-matcher       := create-matcher permits.user, requests.user
      none-matching.permit-matcher  := create-matcher permits.user, requests.ctx

    specify 'does not match access without user' ->
      none-matching.permit-matcher.match!.should.be.false

    specify 'matches access with user' ->
      matching.permit-matcher.match!.should.be.true

  describe 'match access - complex' ->
    before ->
      book := new Book title: 'hello'
      requests.valid :=
        user: {type: 'person', role: 'admin'}
        subject: book

      requests.invalid :=
        user    : {type: 'person', role: 'admin'}
        subject : 'blip'

      requests.alt := {}

      Permit.registry.clean-all!

      permits.user := setup.complex-user!

      matching.permit-matcher       := create-matcher permits.user, requests.valid
      none-matching.permit-matcher  := create-matcher permits.user, requests.invalid

    specify 'does not match access without user' ->
      none-matching.permit-matcher.match!.should.be.false

    specify 'matches access with user' ->
      matching.permit-matcher.match!.should.be.true

  describe 'match access - complex invalid' ->
    before ->
      requests.valid :=
        user    : {type: 'person', role: 'admin'}
        subject : book

      permits.user      := setup.complex-user-returns-matcher!
      permit-matcher    := create-matcher permits.user, requests.valid

      specify 'AccessMatcher chaining in .match which returns AccessMatcher should call result!' ->
        permit-matcher.match!.should.be.true
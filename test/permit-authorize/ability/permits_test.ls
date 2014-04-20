requires        = require '../../../requires'
ability         = require './abilities'

requires.test 'test_setup'

User            = requires.fix 'user'
Book            = requires.fix 'book'

create-request  = requires.fac 'create-request'
create-user     = requires.fac 'create-user'

create-permit   = requires.fac 'create-permit'
create-request  = requires.fac 'create-request'

Ability         = requires.lib 'ability'
Permit          = requires.lib 'permit'

PermitRegistry  = requires.permit 'permit_registry'
PermitFilter    = requires.permit 'permit-filter'

describe 'Ability' ->
  var abook

  permits   = {}
  requests  = {}

  describe 'permits' ->
    before ->
      abook := new Book title: 'book'

      PermitRegistry.clear-all!
      permits.user    = create-permit.matching.user!
      permits.guest   = create-permit.matching.role.guest!
      permits.admin   = create-permit.matching.role.admin!

      requests.empty      = create-request.empty!
      requests.admin      = create-request.role-access 'admin'
      requests.guest      = create-request.role-access 'guest'
      requests.read-book  =
        action: 'read'
        subject: abook

    describe 'permit-filter' ->
      specify 'all permits filtered out on empty request' ->
        PermitFilter.filter(requests.empty).should.eql []

      specify 'only user and guest permit if guest request' ->
        PermitFilter.filter(requests.guest).should.eql [permits.user, permits.guest]

    context 'kris-ability' ->
      # change to match all?
      specify 'empty request matches no permits' ->
        ability.kris.permits(requests.empty).should.eql []

      specify 'admin user request matchies user and admin permits' ->
        ability.kris.permits(requests.admin).should.eql [permits.user, permits.admin]

      specify 'guest user request matchies user and guest permits' ->
        ability.kris.permits(requests.guest).should.eql [permits.user, permits.guest]

    context 'guest-ability' ->
      specify 'no permits allow read book' ->
        ability.guest.permits(requests.read-book).should.eql []
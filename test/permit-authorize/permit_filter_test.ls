requires  = require '../../requires'

requires.test 'test_setup'

User      = requires.fix 'user'
Book      = requires.fix 'book'

create-user     = requires.fac 'create-user'
create-request  = requires.fac 'create-request'
create-permit   = requires.fac 'create-permit'

Permit          = requires.lib 'permit'
PermitRegistry  = requires.permit 'permit_registry'
permit-for      = requires.permit 'permit_for'
PermitFilter    = requires.permit 'permit_filter'

describe 'permit-filter' ->
  permits   = {}
  users     = {}
  requests  = {}

  describe 'user filter' ->
    before ->
      users.javier  := create-user.javier!
      requests.user :=
        user: users.javier

      PermitRegistry.clear-all!
      permits.user := create-permit.matching.user!

    specify 'return only permits that apply for a user' ->
      PermitFilter.filter(requests.user).should.eql [permits.user]

  describe 'guest user filter' ->
    before ->
      PermitRegistry.clear-all!
      users.guest  := create-user.guest!
      requests.guest :=
        user: users.guest

      permits.guest := create-permit.matching.role.guest!

    specify 'return only permits that apply for a guest user' ->
      PermitFilter.filter(requests.guest).should.eql [permits.guest]
      
  describe 'admin user filter' ->
    before ->
      users.admin  := create-user.admin!
      requests.admin :=
        user: users.admin

      permits.admin := create-permit.matching.role.admin!

    specify 'return only permits that apply for an admin user' ->
      PermitFilter.filter(requests.admin).should.eql [permits.admin]

requires  = require '../../../requires'

requires.test 'test_setup'

User      = requires.fix 'user'
Book      = requires.fix 'book'

create-user     = requires.fac 'create-user'
create-request  = requires.fac 'create-request'
create-permit   = requires.fac 'create-permit'

Permit          = requires.lib    'permit'    .Permit
PermitRegistry  = requires.permit 'registry'  .PermitRegistry
permit-for      = requires.permit 'factory'   .permitFor
PermitFilter    = requires.lib    'allower'   .PermitFilter

create-filter = (ar, debug = true) ->
  new PermitFilter ar, debug

describe 'permit-filter' ->
  var pf

  permits   = {}
  users     = {}
  requests  = {}

  describe 'user filter' ->
    before-each ->
      users.javier  := create-user.javier!
      requests.user :=
        user: users.javier

      Permit.registry.clean!
      permits.user  := create-permit.matching.user!
      pf            := create-filter requests.user
      # pf.debug-on!

    specify 'return only permits that apply for a user' ->
      pf.filter!.should.eql [permits.user]

  describe 'guest user filter' ->
    before-each ->
      Permit.registry.clean!
      users.guest  := create-user.guest!
      requests.guest :=
        user: users.guest

      pf := create-filter requests.guest

      permits.guest := create-permit.matching.role.guest!

    specify 'return only permits that apply for a guest user' ->
      pf.filter(requests.guest).should.eql [permits.guest]
      
  describe 'admin user filter' ->
    before-each ->
      Permit.registry.clean!
      users.admin  := create-user.admin!
      requests.admin :=
        user: users.admin

      permits.admin := create-permit.matching.role.admin!

      pf  := create-filter requests.admin

    specify 'return only permits that apply for an admin user' ->
      pf.filter(requests.admin).should.eql [permits.admin]

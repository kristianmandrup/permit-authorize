requires  = require '../../../../requires'

requires.test 'test_setup'

User      = requires.fix 'user'
Book      = requires.fix 'book'

Permit          = requires.lib    'permit'    .Permit
PermitRegistry  = requires.permit 'registry'  .PermitRegistry
PermitFactory   = requires.permit 'factory'   .PermitFactory
permit-for      = requires.permit 'factory'   .permitFor

class AdminPermit extends Permit
  type: 'admin'

describe 'permit-for' ->
  permits = {}

  context 'multiple guest permits' ->

    before ->
      permits.guest := permit-for 'Guest',
        number: 1
        match: (access) ->
          @matching(access).role 'guest'

    specify 'guest permit is a Permit' ->
      permits.guest.constructor.should.eql Permit

    specify 'guest permit name is Guest' ->
      permits.guest.name.should.eql 'Guest'

    specify 'creating other Guest permit throws error' ->
      ( -> permit-for 'Guest' ).should.throw

  context 'one admin permit' ->
    var admin-permit
    
    before ->
      Permit.registry?.clean!
      admin-permit := permit-for AdminPermit, 'Admin',
        rules:
          admin: ->
            @ucan 'manage', 'all'

    specify 'creates a permit' ->
      admin-permit.constructor.should.eql AdminPermit

    specify 'has the name Admin' ->
      admin-permit.name.should.eql 'Admin'

    # from AdminPermit class :)
    specify 'has the type Admin' ->
      admin-permit.type.should.eql 'admin'

    specify 'sets rules to run' ->
      admin-permit.rules.should.be.an.instanceOf Object

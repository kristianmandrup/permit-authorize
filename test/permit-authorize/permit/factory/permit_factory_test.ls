requires  = require '../../../../requires'

requires.test 'test_setup'

Permit          = requires.lib    'permit'    .Permit
PermitFactory   = requires.permit 'factory'   .PermitFactory

class AdminPermit extends Permit
  type: 'admin'

describe 'PermitFactory' ->
  permits = {}

  context 'multiple guest permits' ->

    before ->
      permits.guest := new PermitFactory('Guest', {
        number: 1
        match: (access) ->
          @matching(access).role 'guest'
      }).create!

    specify 'guest permit is a Permit' ->
      permits.guest.constructor.display-name.should.eql 'Permit'

    specify 'guest permit name is Guest' ->
      permits.guest.name.should.eql 'Guest'

    specify 'creating other Guest permit throws error' ->
      ( -> permit-for 'Guest' ).should.throw
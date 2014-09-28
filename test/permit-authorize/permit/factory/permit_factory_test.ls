requires  = require '../../../../requires'

requires.test 'test_setup'

Permit          = requires.lib    'permit'    .Permit
PermitFactory   = requires.permit 'factory'   .PermitFactory

class AdminPermit extends Permit
  type: 'admin'

expect = require 'chai' .expect

describe 'PermitFactory' ->
  permits = {}

  var fun

  describe 'create with function' ->
    before-each ->
      fun := ->
        rules:
          ctx:
            area:
              visitor: ->
                @ucan 'publish', 'Paper'
          read: ->
            @ucan 'read' 'Book'
          write: ->
            @ucan 'write' 'Book'
          default: ->
            @ucan 'read' 'any'

      permits.fun-guest = new PermitFactory('guest books', fun, false).create!
      # console.log permits.fun-guest.rules

    describe 'rules' ->
      specify 'should be an object' ->
        expect (typeof! permits.fun-guest.rules) .to.eql 'Object'

      specify 'read be a Function' ->
        expect (typeof! permits.fun-guest.rules.read) .to.eql 'Function'

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

    describe 'use' ->

    describe 'create' ->
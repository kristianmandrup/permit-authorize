requires  = require '../../../../requires'

requires.test 'test_setup'

Book            = requires.fix 'book'
AccessRequest   = requires.lib 'access-request' .AccessRequest

fingerprint     = requires.lib 'access-request' .fingerprint
FingerPrinter   = fingerprint.FingerPrinter

describe 'Fingerprints' ->
  var access-request

  finger-printer = (ar, debug = true) ->
    new FingerPrinter ar, debug

  before ->
    access-request := {user: {name: 'Kris'}, action: 'read'}

  describe 'fingerprint' ->
    specify 'has method access-hash' ->
      finger-printer(access-request).fingerprint!.should.not.eql void



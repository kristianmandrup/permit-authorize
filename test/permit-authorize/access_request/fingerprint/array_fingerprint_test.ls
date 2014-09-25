requires  = require '../../../../requires'

requires.test 'test_setup'

Book            = requires.fix 'book'
AccessRequest   = requires.lib 'access-request' .AccessRequest

fingerprint     = requires.lib 'access-request' .fingerprint
FingerPrinter   = fingerprint.ArrayFingerPrint

describe 'ArrayFingerPrint' ->
  var access-request

  finger-printer = (ar, debug = true) ->
    new FingerPrinter ar, debug

  before ->
    access-request := ['hello', 'goodbye']

  describe 'fingerprint' ->
    specify 'makes a fingerprint' ->
      res = finger-printer(access-request).fingerprint!
      res.should.eql 'hello.goodbye'



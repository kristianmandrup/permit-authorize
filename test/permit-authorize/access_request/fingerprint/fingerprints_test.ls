requires  = require '../../../requires'

requires.test 'test_setup'

Book            = requires.fix 'book'
AccessRequest   = requires.lib 'access-request'

Fingerprints  = requires.access-request 'fingerprints'

console.log Fingerprints

describe 'Fingerprints' ->
  specify 'has method access-hash' ->
    Fingerprints.access-hash.should.not.eql void

describe 'AccessRequest' ->
  var book, access-request

  requests = {}

  before ->
    book := new Book 'a book'

    requests.complex :=
      user:
        role: 'admin'
      action: ['read', 'write']
      subject: book

    access-request := AccessRequest.from(requests.complex)

  describe 'user-hash' ->
    specify 'is JSON stringify when no hash' ->
      access-request.user-hash!.should.eql "{\"role\":\"admin\"}"

  describe 'action-hash' ->
    specify 'is actions joined by . when Array' ->
      access-request.action-hash!.should.eql "read.write"

  describe 'subject-fingerprint' ->
    # (@user, @action, @subject, @ctx, debug) ->
      # @validate! ; @normalize!
    specify 'is JSON stringify when no hash' ->
      access-request.subject-hash!.should.eql "{\"obj\":\"a book\"}"

  describe 'ctx-hash' ->
    specify 'is void of undefined' ->
      access-request.ctx-hash!.should.eql 'x'

  describe 'access-hash' ->
    specify 'is combination of all fingerprints' ->
      access-request.access-hash!.should.eql "read.write:{\"obj\":\"a book\"}:x"

requires  = require '../../../requires'

requires.test 'test_setup'

Book            = requires.fix 'book'
AccessRequest   = requires.lib 'access-request' .AccessRequest

describe 'AccessRequest' ->
  var book, access-request

  requests = {}

  before ->
    book := new Book 'a book'

    requests.complex :=
      user:
        role: 'admin'
      action: 'read'
      subject: book

  # factory method
  describe 'from' ->
    # new AccessRequest(obj.user, obj.action, obj.subject, obj.ctx)
    specify 'creates access request from object' ->
      AccessRequest.from(requests.complex).constructor.should.equal AccessRequest

  # constructor
  describe 'initialize' ->
    # (@user, @action, @subject, @ctx, debug) ->
      # @validate! ; @normalize!
    specify 'valid args creates it' ->
      new AccessRequest({name: 'kris'}, 'read', 'Book').constructor.should.equal AccessRequest

  context 'instance' ->
    before-each ->
      access-request := new AccessRequest {name: 'kris'}, 'read', 'Book'

    # normalize action and subject if they are not each a String
    describe 'normalize' ->
      specify 'normalizes action' ->
        access-request.action = 'read'
        access-request.normalize!.action.should.eql ['read']

      specify 'and subject' ->
        access-request.subject = 'book'
        access-request.normalize!.subject.should.eql ['book']

    describe 'validate' ->
      specify 'invalid subject throws' ->

      specify 'valid args does not throw' ->
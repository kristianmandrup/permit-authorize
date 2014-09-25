requires        = require '../../../../requires'

requires.test 'test_setup'

Matcher   = requires.lib 'access_request' .matcher.SubjectMatcher

Book      = requires.fix 'book'

matcher = (req) ->
  new Matcher req

create-book = (title) ->
  new Book title: title

describe 'SubjectMatcher' ->
  var subject-matcher  
  var book, book-title
  requests = {}

  before ->
    book := create-book 'the return of the jedi'
    requests.book :=
      subject: book

  describe 'create' ->
    before-each ->
      subject-matcher  := matcher requests.book

    specify 'must have admin access request' ->
      subject-matcher.access-request.should.eql  requests.book

  describe 'match' ->
    before-each ->
      subject-matcher  := matcher requests.book

    specify 'should match book: the return of the jedi' ->
      subject-matcher.match(title: book.title).should.be.true

    specify 'should NOT match book: the return to oz' ->
      subject-matcher.match(title: 'the return to oz').should.be.false

    specify 'should match on no argument' ->
      subject-matcher.match!.should.be.true
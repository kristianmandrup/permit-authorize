requires  = require '../../requires'

requires.test 'test_setup'

_          = require 'prelude-ls'

User      = requires.fix 'user'
Book      = requires.fix 'book'

RuleRepo      = requires.rule 'rule_repo'
PermitAllower = requires.permit 'permit_allower'

describe 'PermitAllower' ->
  var rule-repo, permit-allower
  var book, def-user

  def-user = new User role: 'guest'

  user-request = (action, subject) ->
    user: def-user
    action: action
    subject: subject

  book-request = (action) ->
    user-request action, 'book'

  before ->
    # setup for all tests
    rule-repo := new RuleRepo
    book      := new Book 'Far and away'

    permit-allower := new PermitAllower rule-repo

  context 'test helpers' ->
    describe 'user-request' ->
      specify 'has default user ' ->
        user-request('read', 'paper').user.should.eql def-user

      specify 'has subject book' ->
        user-request('read', 'paper').subject.should.eql 'paper'

      specify 'has action read' ->
        user-request('read', 'paper').action.should.eql 'read'

    describe 'book-request' ->
      specify 'has subject book' ->
        book-request('read').subject.should.eql 'book'

      specify 'has action read' ->
        book-request('read').action.should.eql 'read'


  describe 'init' ->
    specify 'has a rule repo' ->
      permit-allower.should.have.a.property 'ruleRepo'

    specify 'rule repo is a RuleRepo' ->
      permit-allower.rule-repo.constructor.should.be.eql RuleRepo

  describe 'test-access' ->
    var read-book-rule, publish-book-rule, lc-publish-book-rule
    
    before ->
      read-book-rule :=
        action: 'read'
        subject: 'Book'

      publish-book-rule :=
        action: 'publish'
        subject: 'Book'

      lc-publish-book-rule :=
        action: 'publish'
        subject: 'book'

    context 'can read book' ->
      before-each ->
        rule-repo.clear!
        rule-repo.register-rule 'can', 'read', 'Book'

      specify 'finds match for can read/Book' ->
        permit-allower.test-access('can', read-book-rule).should.be.true

    context 'can publish book' ->
      before-each ->
        rule-repo.clear!
        rule-repo.register-rule 'can', 'publish', 'Book'

      specify 'does NOT find match for can read/Book' ->
        permit-allower.test-access('can', read-book-rule).should.be.false

      specify 'finds match for can publish/Book' ->
        permit-allower.test-access('can', publish-book-rule).should.be.true

      specify 'finds match for can publish/book' ->
        permit-allower.test-access('can', lc-publish-book-rule).should.be.true

  describe 'allows' ->
    var read-book-request, publish-book-request

    before-each ->
      read-book-request  := book-request 'read'
      publish-book-request := book-request 'publish'

    context 'can read book' ->
      before ->
        rule-repo.register-rule 'can', 'read', 'Book'

      specify 'should allow guest user to read a book' ->
        permit-allower.allows(read-book-request).should.be.true

    context 'cannot publish book' ->
      before-each ->
        rule-repo.clear!
        rule-repo.register-rule 'cannot', 'publish', 'Book'

      specify 'does NOT allow guest user to publish a book' ->
        permit-allower.allows(publish-book-request).should.be.false

  describe 'disallows' ->
    var read-book-request, publish-book-request

    before ->
      read-book-request  := book-request 'read'
      publish-book-request := book-request 'publish'

    context 'cannot publish book' ->
      before-each ->
        rule-repo.clear!
        rule-repo.register-rule 'cannot', 'publish', 'Book'

      specify 'should disallow guest user from publishing a book' ->
        permit-allower.disallows(publish-book-request).should.be.true

    context 'can read book' ->
      before-each ->
        rule-repo.clear!
        rule-repo.register-rule 'can', 'read', 'Book'

      specify 'does NOT disallow guest user from reading a book' ->
        permit-allower.disallows(read-book-request).should.be.false

    context 'cannot read book' ->
      before-each ->
        rule-repo.clear!
        rule-repo.register-rule 'cannot', 'read', 'Book'

      specify 'should disallow guest user from reading a book' ->
        permit-allower.disallows(read-book-request).should.be.true

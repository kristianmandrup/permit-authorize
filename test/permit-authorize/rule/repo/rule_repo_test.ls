requires  = require '../../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

RuleRepo    = requires.rule 'repo/rule_repo'

expect = require 'chai' .expect

describe 'Rule Repository (RuleRepo)' ->
  var access-request, rule, rule-repo
  var book
  var can, cannot

  create-rule-repo = (name, debug) ->
    new RuleRepo name, debug

  context 'basic repo' ->
    before ->
      rule-repo := create-rule-repo 'repo'
      #book      := new Book 'Far and away'

    specify 'has can-rules' ->
      rule-repo.can-rules.should.be.an.instanceof Object

    specify 'has cannot-rules' ->
      rule-repo.can-rules.should.be.an.instanceof Object

    describe 'container-for' ->
      specify 'can' ->
        rule-repo.container-for('can').should.eql rule-repo.can-rules

      specify 'cannot' ->
        rule-repo.container-for('cannot').should.eql rule-repo.cannot-rules


    describe 'register-rule' ->
      before ->
        rule-repo.clean!

      specify 'can register a valid rule' ->
        rule-repo.register-rule('can', 'read', 'Book')
        rule-repo.should.have.property('canRules')
        rule-repo.can-rules.should.eql {'read': ['Book']} # eql include

      specify 'throws error on invalid rule' ->
        ( -> rule-repo.register-rule 'can', 'read', null).should.throw!


    describe 'add-rule' ->
      context 'valid' ->
        before ->
          rule-repo.clean!
          container = rule-repo.can-rules
          rule-repo.add-rule(container, 'read', 'Book')

        specify 'can-rules contains read book rule' ->
          rule-repo.can-rules.should.eql { 'read': ['Book'] }

      context 'invalid' ->
        specify 'throws error if container is null' ->
          ( -> rule-repo.add-rule null, 'read', 'Book' ).should.throw!

        specify 'throws error if container is not an Object' ->
          ( -> rule-repo.add-rule [], 'read', 'Book' ).should.throw!

    describe 'find-matching-subject' ->
      var books

      before ->
        rule-repo.clean!
        book := new Book title: 'hi molly'
        books := ['Book', void]

      specify 'matches book on list of books' ->
        rule-repo.find-matching-subject(books, 'book').should.be.true

      specify 'matches Book on list of books' ->
        rule-repo.find-matching-subject(books, 'Book').should.be.true

      specify 'does not match BoAk on list of books' ->
        rule-repo.find-matching-subject(books, 'BoAk').should.be.false

  describe 'match-rule' ->
    context 'can-rules - read book' ->
      before ->
        rule-repo := create-rule-repo 'repo', true

        rule-repo.can-rules =
          'read': ['Book']

      specify 'can find rule that allows user to read a book' ->
        read-book-rule = {action: 'read', subject: 'Book'}
        rule-repo.match-rule('can', read-book-rule).should.be.true

      specify 'can NOT find rule that allows user to publish a book' ->
        publish-book-rule = {action: 'publish', subject: 'Book'}
        rule-repo.match-rule('can', publish-book-rule).should.be.false
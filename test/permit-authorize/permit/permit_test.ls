requires  = require '../../../requires'

requires.test 'test_setup'

Permit          = requires.lib    'permit'  .Permit
RuleRepo        = requires.rule   'repo'    .RuleRepo
RuleApplier     = requires.permit 'rule'    .PermitRuleApplier

PermitMatcher   = requires.permit 'matcher' .PermitMatcher
permit-for      = requires.permit 'factory' .permitFor

Book            = requires.fix  'book'

describe 'Permit' ->
  permits = {}

  before ->
    permits.hello := new Permit 'hello'

  xdescribe 'clean' ->
    # TODO

  describe 'matcher' ->
    var access-request

    before ->
      access-request := {}

    specify 'can NOT create matcher without access request' ->
      ( -> permits.hello.matcher!).should.throw

    specify 'create matcher with access request' ->
      permits.hello.matcher(access-request).constructor.should.eql PermitMatcher

  describe 'rule-applier' ->
    var access-request

    before ->
      access-request := {}
      permits.hello.rules = ->

    specify 'has a rule-applier' ->
      permits.hello.rule-applier!.constructor.should.eql RuleApplier

    describe 'constructed with access request' ->
      specify 'has a rule-applier ' ->
        permits.hello.rule-applier(access-request).constructor.should.eql RuleApplier

      specify 'and rule-applier has access request' ->
        permits.hello.rule-applier(access-request).access-request.should.eql access-request

  describe 'matches' ->
    var book, read-book-request, publish-book-request

    make-request = (action) ->
        user: {}
        action: action
        subject: book

    before ->
      book                  := new Book 'a book'
      read-book-request     := make-request 'read'
      publish-book-request  := make-request 'publish'

      permits.hello.match = (access) ->
        @matching(access).match-on action: 'read'

    specify 'will match request to read a book' ->
      permits.hello.matches(read-book-request).should.be.true

    specify 'will NOT match request to publish a book' ->
      permits.hello.matches(publish-book-request).should.be.false

    describe 'matches-on' ->
      context 'roles and actions' ->
        before ->
          permits.on-multi = permit-for('on-multi',
            matches-on:
              roles: ['editor', 'publisher']
              actions: ['edit', 'write', 'publish']
          )

        specify 'match' ->
          # permits.special.debug-on!
          permits.on-multi.matches(publish-book-request).should.be.true

      context 'role and action' ->
        before ->
          permits.on-single = permit-for('on-single',
            matches-on:
              action: 'publish'
              role: 'publisher'
          )

        specify 'match' ->
          # permits.on-single.debug-on!
          permits.on-single.matches(publish-book-request).should.be.true

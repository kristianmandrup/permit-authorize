requires  = require '../../requires'

requires.test 'test_setup'

_         = require 'prelude-ls'

Permit          = requires.lib 'permit'
RuleRepo        = requires.rule 'rule_repo'
RuleApplier     = requires.rule 'rule_applier'

PermitMatcher   = requires.permit 'permit_matcher'
PermitAllower   = requires.permit 'permit_allower'
permit-for      = requires.permit 'permit_for'

Book            = requires.fix  'book'

describe 'Permit' ->
  permits = {}

  before ->
    permits.hello := new Permit 'hello'

  describe 'use' ->
    context 'single permit named hello' ->
      specify 'using Object adds object to permit' ->
        permits.hello.use {state: 'on'}
        permits.hello.state.should.eql 'on'

      specify 'using Function adds object received from calling function to permit' ->
        permits.hello.use ->
          {state: 'off'}
        permits.hello.state.should.eql 'off'

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


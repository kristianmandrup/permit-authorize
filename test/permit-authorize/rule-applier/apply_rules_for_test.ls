requires        = require '../../../requires'

requires.test 'test_setup'

_             = require 'prelude-ls'

User          = requires.fix 'user'
Book          = requires.fix 'book'

RuleApplier   = requires.rule 'rule_applier'
RuleRepo      = requires.rule 'rule_repo'

rules         = require './rules'

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  before ->
    book          := new Book 'Far and away'

  describe 'apply-rules-for' ->
    var access-request, rule-repo, rule-applier, rules

    before ->
      rules := setup.basic-rules

      access-request :=
        action: 'read'
        subject: book

      rule-repo     := new RuleRepo
      rule-applier  := new RuleApplier rule-repo, rules, access-request

      rule-applier.apply-rules-for 'edit'

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        edit: ['Book']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        write: ['Book']
      }

  describe 'apply-action-rules-for :read' ->
    var read-access-request, rule-repo, rule-applier, rules

    before ->
      rules         :=
        edit: ->
          @ucan     'edit',   'Book'
          @ucannot  'write',  'Book'
        read: ->
          @ucan    'read',   'Project'
          @ucannot 'delete', 'Paper'

      read-access-request :=
        action: 'read'
        subject: book

      # adds only the 'read' rules (see access-request.action)
      rule-repo     := new RuleRepo('action repo').clear!
      rule-applier  := new RuleApplier rule-repo, rules, read-access-request

      rule-applier.apply-action-rules!

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        read: ['Project']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        delete: ['Paper']
      }
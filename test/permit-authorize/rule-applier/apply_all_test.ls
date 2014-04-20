requires        = require '../../../requires'

requires.test 'test_setup'

_             = require 'prelude-ls'

User          = requires.fix 'user'
Book          = requires.fix 'book'

RuleApplier   = requires.rule 'rule_applier'
RuleRepo      = requires.rule 'rule_repo'

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  before ->
    book          := new Book 'Far and away'

  describe 'apply-all' ->
    var read-access-request, rule-repo, rule-applier, rules

    before ->
      read-access-request :=
        action: 'read'
        subject: book

      rules         :=
        edit: ->
          @ucan     'edit',   'Book'
        read: ->
          @ucan     'read',   'Project'
        default: ->
          @ucannot  'write', 'Book'

      rule-repo     := new RuleRepo('action repo').clear!
      rule-applier  := new RuleApplier rule-repo, rules, read-access-request

      rule-applier.apply-all-rules!

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        edit: ['Book']
        read: ['Project']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        write: ['Book']
      }

    context 'double execution' ->
      var read-access-request, rule-repo, rule-applier, rules

      before ->
        read-access-request :=
          action: 'read'
          subject: book

        rules         :=
          edit: ->
            @ucan     'edit',   'Book'
          read: ->
            @ucan     'read',   ['Project', 'project']
          default: ->
            @ucannot  'write', 'Book'
            @ucan     'edit',  'book'

        rule-repo     := new RuleRepo('action repo').clear!
        rule-applier  := new RuleApplier rule-repo, rules, read-access-request

        rule-applier.apply-all-rules!
        rule-applier.apply-all-rules!

      specify 'adds all can rules - one time' ->
        rule-repo.can-rules.should.be.eql {
          edit: ['Book']
          read: ['Project']
        }

      specify 'adds all cannot rules - one time' ->
        rule-repo.cannot-rules.should.be.eql {
          write: ['Book']
        }
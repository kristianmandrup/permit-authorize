requires        = require '../../../requires'

requires.test 'test_setup'

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
    book  := new Book 'Far and away'

  describe 'apply-rules' ->
    describe 'static' ->
      var read-access-request, rule-repo, rule-applier, rules

      before ->
        rules         :=
          edit: ->
            @ucan     'edit',   'Book'
            @ucannot  'write',  'Book'
          read: ->
            @ucan    'read',   'Project'
            @ucannot 'delete', 'Paper'
          default: ->
            @ucan    'read',   'Paper'

        read-access-request :=
          action: 'read'
          subject: book

        # adds only the 'read' rules (see access-request.action)
        rule-repo     := new RuleRepo('static repo').clear!
        rule-applier  := new RuleApplier rule-repo, rules

        rule-applier.apply-rules!

      specify 'adds all static can rules' ->
        rule-repo.can-rules.should.be.eql {
          read: ['Paper']
        }

      specify 'adds all static cannot rules' ->
        rule-repo.cannot-rules.should.be.eql {
        }

    describe 'dynamic' ->
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

        rule-applier.apply-rules read-access-request

      specify 'adds all dynamic can rules (only read)' ->
        rule-repo.can-rules.should.be.eql {
          read: ['Project']
        }

      specify 'adds all dynamic cannot rules (only read)' ->
        rule-repo.cannot-rules.should.be.eql {
          delete: ['Paper']
        }
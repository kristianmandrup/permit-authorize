requires        = require '../../../../../requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

RulesApplier      = requires.rule 'apply' .DynamicApplier
RuleRepo          = requires.rule 'repo'  .RuleRepo
ExecutionContext  = requires.rule 'apply' .ExecutionContext

rules         = requires.fix-rules 'rules'

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  create-repo = (name = 'dynamic repo', debug = false) ->
    new RuleRepo name, debug .clean!

  create-exec-ctx = (debug = true) ->
    new ExecutionContext create-repo!, debug

  create-rules-applier = (rules, access-request, debug = true) ->
    new RulesApplier create-exec-ctx!, rules, access-request, debug

  exec-rule-applier = (rules, action-request) ->
    create-rules-applier(rules, action-request).apply-rules!

  before ->
    book  := new Book 'Far and away'

  describe 'apply-action-rules-for :read' ->
    var read-access-request, rule-repo, rule-applier, rules

    before ->
      rules :=
        ctx:
          guest-area: ->
            @ucan     'edit',   'Book'
            @ucan     'read',   'Book'
            @ucannot  'write',  'Book'

          admin-area: ->
            @ucan    'read',   'Project'
            @ucannot 'delete', 'Paper'

      read-access-request :=
        action: 'read'
        subject: book
        ctx:
          guest-area: true

      # adds only the 'read' rules (see access-request.action)
      rule-applier  := create-rules-applier rules, read-access-request
      rule-repo     := rule-applier.repo!
      rule-applier.apply-ctx-rules!

      console.log 'REPO', rule-repo.container!

    specify 'adds all dynamic can rules (only read)' ->
      rule-repo.can-rules!.should.be.eql {
        read: ['Book']
      }

    specify 'adds all dynamic cannot rules (only read)' ->
      rule-repo.cannot-rules!.should.be.eql {
        write: ['Book']
      }

requires        = require '../../../../../requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

RulesApplier   = requires.rule 'apply' .DynamicApplier
RuleRepo      = requires.rule 'repo' .RuleRepo

fix-rules   = requires.fix-rules 'rules'

create-rules-applier = (rule-repo, rules, read-access-request, debug = true) ->
  new RulesApplier rule-repo, rules, read-access-request, debug

create-repo = (name = 'dynamic repo', debug = false) ->
  new RuleRepo name, debug .clear!

create-exec-ctx = ->
  new ExecutionContext create-repo!

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  before ->
    book  := new Book 'Far and away'

  describe 'dynamic' ->
    var read-access-request, rule-repo, rule-applier, rules

    before ->
      rules :=
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
      rule-applier  := create-rules-applier create-exec-ctx!, rules, read-access-request, true

      rule-applier.apply-rules!

    specify 'adds all dynamic can rules (only read)' ->
      rule-repo.can-rules.should.be.eql {
        read: ['Project']
      }

    specify 'adds all dynamic cannot rules (only read)' ->
      rule-repo.cannot-rules.should.be.eql {
        delete: ['Paper']
      }
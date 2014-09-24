requires        = require '../../../../../requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

RulesApplier  = requires.rule 'apply' .DynamicApplier
RuleRepo      = requires.rule 'repo' .RuleRepo

rules         = requires.fix-rules 'rules'

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  create-rules-applier = (rule-repo, rules, read-access-request) ->
    new RulesApplier rule-repo, rules, read-access-request

  create-repo = (name = 'dynamic repo', debug) ->
    new RuleRepo name, debug .clear!

  before ->
    book  := new Book 'Far and away'

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
      rule-repo     := create-repo 'action repo', true
      rule-applier  := create-rules-applier rule-repo, rules, read-access-request

      rule-applier.apply-action-rules!
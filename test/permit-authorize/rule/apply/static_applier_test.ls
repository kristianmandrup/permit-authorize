requires  = require '../../../../requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

console.log requires.rule

RulesApplier      = requires.rule 'apply' .StaticApplier
ExecutionContext  = requires.rule 'apply' .ExecutionContext

RuleRepo          = requires.rule 'repo' .RuleRepo

# Note: Use rule-repo.display! for debugging internals of RuleRepo instances after rule application

describe 'StaicApplier' ->
  var book
  var rule-repo
  var rule-applier

  rules = {}

  applier = (ctx, rules, debug = true) ->
    new RulesApplier ctx, rules, debug

  create-repo = (name = 'dynamic repo', debug = false) ->
    new RuleRepo(name, debug).clear!

  create-exec-ctx = (debug = true) ->
    new ExecutionContext(create-repo!, debug)

  create-rule-applier = (rules) ->
    applier(create-exec-ctx!, rules, true)

  exec-rule-applier = (rules, action-request) ->
    create-rule-applier(rules).apply-rules!

  before ->
    book          := new Book 'Far and away'

  # can create, edit and delete a Book
  describe 'manage paper' ->
    context 'applied default rule: manage Paper' ->
      before ->
        rules.manage-paper :=
          default: ->
            @ucan    'manage',   'Paper'

        rule-applier  := exec-rule-applier rules.manage-paper
        rule-repo     := rule-applier.repo!

      specify 'should add create, edit and delete can-rules' ->
        rule-repo.can-rules.should.eql {
          manage: ['Paper']
          create: ['Paper']
          edit:   ['Paper']
          delete: ['Paper']
        }


    describe 'apply-rules' ->
      describe 'static' ->
        var rule-repo, rule-applier, rules

        before ->
          rules :=
            edit: ->
              @ucan     'edit',   'Book'
              @ucannot  'write',  'Book'
            read: ->
              @ucan    'read',   'Project'
              @ucannot 'delete', 'Paper'
            default: ->
              @ucan    'read',   'Paper'

          # adds only the 'read' rules (see access-request.action)
          rule-applier := exec-rule-applier rules
          rule-repo    := rule-applier.repo!

        specify 'adds all static can rules' ->
          rule-repo.can-rules.should.be.eql {
            read: ['Paper']
          }

        specify 'adds all static cannot rules' ->
          rule-repo.cannot-rules.should.be.eql {
          }
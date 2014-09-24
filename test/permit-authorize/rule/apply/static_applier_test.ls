requires  = require '../../../../requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

console.log requires.rule

StaticApplier   = requires.rule 'apply' .StaticApplier
RuleRepo        = requires.rule 'repo' .RuleRepo

# Note: Use rule-repo.display! for debugging internals of RuleRepo instances after rule application

describe 'StaicApplier' ->
  var book
  var rule-repo
  var rule-applier

  rules = {}

  create-repo = (name = 'static repo', debug = true) ->
    new RuleRepo name, debug .clear!

  applier = (repo, rules, debug) ->
    new StaticApplier repo, rules, debug

  create-rule-applier = (rules, action-request) ->
    rule-repo := create-repo!
    rule-applier := applier rule-repo, rules, true

  exec-rule-applier = (rules, action-request) ->
    rule-applier := create-rule-applier(rules, action-request).apply-rules!

  before ->
    book          := new Book 'Far and away'

  # can create, edit and delete a Book
  describe 'manage paper' ->
    context 'applied default rule: manage Paper' ->
      before ->
        rules.manage-paper :=
          default: ->
            @ucan    'manage',   'Paper'

        exec-rule-applier rules.manage-paper

      specify 'should add create, edit and delete can-rules' ->
        rule-repo.can-rules.should.eql {
          manage: ['Paper']
          create: ['Paper']
          edit:   ['Paper']
          delete: ['Paper']
        }


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
        rule-repo     := create-repo! .clear!
        rule-applier  := create-rules-applier rule-repo, rules

        rule-applier.apply-rules!

      specify 'adds all static can rules' ->
        rule-repo.can-rules.should.be.eql {
          read: ['Paper']
        }

      specify 'adds all static cannot rules' ->
        rule-repo.cannot-rules.should.be.eql {
        }
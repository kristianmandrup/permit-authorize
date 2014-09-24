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

  create-repo = ->
    new RuleRepo('static repo', true).clear!

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
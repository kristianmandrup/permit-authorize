requires        = require '../../../../../requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

RulesApplier  = requires.rule 'apply' .DynamicApplier
RuleRepo      = requires.rule 'repo' .RuleRepo

fix-rules   = requires.fix-rules 'rules'
console.log 'RulesApplier', RulesApplier

describe 'Rule Applier (RuleApplier)' ->
  var book

  debug-repo = (txt, repo) ->
    console.log txt, repo
    console.log repo.can-rules
    console.log repo.cannot-rules

  create-rules-applier = (rule-repo, rules, read-access-request) ->
    new RulesApplier rule-repo, rules, read-access-request

  create-repo = (name = 'repo', debug = true) ->
    new RuleRepo name, debug .clear!

  before ->
    book  := new Book 'Far and away'

  describe 'apply-rules-for' ->
    var access-request, rule-repo, rule-applier, rules

    before ->
      rules := fix-rules.basic

      access-request :=
        action: 'read'
        subject: book

      rule-repo     := create-repo!
      rule-applier  := create-rules-applier rule-repo, rules, access-request

      rule-applier.apply-rules-for 'edit'

    specify 'adds all can rules' ->
      rule-repo.can-rules.should.be.eql {
        edit: ['Book']
      }

    specify 'adds all cannot rules' ->
      rule-repo.cannot-rules.should.be.eql {
        write: ['Book']
      }

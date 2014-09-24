requires  = require '../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

User          = requires.fix 'user'
Book          = requires.fix 'book'

RuleRepo          = requires.rule 'repo'  .RuleRepo
ExecutionContext  = requires.rule 'apply' .ExecutionContext

# Note: Use rule-repo.display! for debugging internals of RuleRepo instances after rule application

describe 'ExecutionContext' ->
  var book
  var rule-repo

  rules = {}

  create-repo = ->
    new RuleRepo('static repo').clear!

  describe 'create ExecuteContext' ->
    context 'with no repo' ->
      specify 'throws error' ->
        expect( -> new ExecutionContext).to.throw

    context 'with a valid repo' ->
      specify 'creates with the repo' ->
        expect( -> new ExecutionContext create-repo!).to.not.throw

    context 'ExecuteContext with valid repo' ->
      var ctx
      before ->
        ctx := new ExecutionContext create-repo!

      describe 'ucan' ->
        # ucan: (actions, subjects, ctx) ->
        #   @repo.register-rule 'can', actions, subjects, ctx
        specify 'registers new can rule in repo' ->
          ctx.ucan('edit', 'Book')
          ctx.repo.canRules.should.eql {
            edit: ['Book']
          }


      describe 'ucannot' ->
        # ucannot: (actions, subjects, ctx) ->
        #   @repo.register-rule 'cannot', actions, subjects, ctx
        specify 'registers new cannot rule in repo' ->
          ctx.ucannot('edit', 'Book')
          ctx.repo.cannotRules.should.eql {
            edit: ['Book']
          }


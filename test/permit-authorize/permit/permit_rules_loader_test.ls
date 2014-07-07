requires        = require '../../../requires'
requires.test 'test_setup'
chai = require 'chai'
expect = chai.expect

Permit            = requires.lib 'permit'
PermitRegistry    = requires.permit 'permit-registry'
RuleRepo          = requires.rule 'rule_repo'
PermitRulesLoader = requires.permit 'permit_rules_loader'

describe 'Permit' ->
  var rules-loader, loaded-rules, file-path, basic-rules-file-path
  permits = {}

  describe 'rules loader' ->
    before-each ->
      rules-loader := new PermitRulesLoader
      basic-rules-file-path := './test/rules/basic-rules.json'

    # clean up!
    after-each ->
      PermitRegistry.clear-all!

    context 'bad file path' ->
      specify 'file load error' ->
        expect(-> rules-loader.load-rules 'rules.json', false).to.throw new Error

    context 'good file path'  ->
      specify 'loads rules' ->
        expect(-> rules-loader.load-rules basic-rules-file-path).to.not.throw Error

      context 'loaded' ->
        before-each ->
          rules-loader.load-rules basic-rules-file-path, false

        specify 'has loaded rules' ->
          # console.log rules-loader
          expect(rules-loader.loaded-rules).to.not.be.empty

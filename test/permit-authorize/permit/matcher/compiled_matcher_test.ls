requires  = require '../../../../requires'

requires.test 'test_setup'

Matcher = requires.permit 'matcher' .CompiledMatcher

expect = require 'chai' .expect

describe 'CompiledMatcher' ->
  var valid-context

  before ->
    valid-context :=
      name: 'hello'
      matches-on:
        role: ['editor', 'admin']
        action: ['read']

      match-on: (ar) ->
        true

  describe 'create w invalid context' ->
    specify 'throws' ->
      expect( -> new Matcher).to.throw

  describe 'create w valid context' ->
    specify 'throws' ->
      expect( -> new Matcher valid-context).to.not.throw


  context 'created w context missin matchOn fun' ->
    var compiler, compiled, no-match-context

    before ->
      no-match-context :=
        role: ['editor', 'admin']
        action: ['read']

      compiler := new Matcher no-match-context, true

    describe 'matching' ->
      specify 'throws' ->
        expect(-> compiler.match!).to.throw

  context 'created w context' ->
    var compiler, compiled

    before ->
      compiler := new Matcher valid-context, true

    describe 'matching compiled' ->
      before ->
        compiled := compiler.match!

      specify 'nothing' ->
        console.log compiled
        expect(compiled).to.eql false

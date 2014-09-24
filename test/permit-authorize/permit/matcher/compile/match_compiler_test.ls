requires  = require '../../../../../requires'

requires.test 'test_setup'

MatchCompiler = requires.permit 'matcher' .compile.MatchCompiler

expect = require 'chai' .expect

describe 'MatchCompiler' ->
  describe 'create w invalid context' ->
    specify 'throws' ->
      expect( -> new MatchCompiler).to.throw

  describe 'create w valid context' ->
    specify 'throws' ->
      expect( -> new MatchCompiler valid-context).to.not.throws


  context 'created w context' ->
    var compiler, compiled

    before ->
      compiler := new MatchCompiler valid-context

    describe 'compile type, match' ->
      before ->
        compiled := compiler.compile 'role', ['editor', 'admin']

      specify 'compiles' ->
        expect(compiled).to.eql {}

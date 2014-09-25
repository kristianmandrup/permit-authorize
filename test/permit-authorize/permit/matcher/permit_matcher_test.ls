requires  = require '../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

Matcher = requires.permit 'matcher' .PermitMatcher

pm = (ctx, ar, debug = true) ->
  new Matcher ctx, ar

ctx = {}
ar  = {}

describe 'PermitMatcher' ->
  before ->

  describe 'create' ->
    describe 'invalid ar' ->
      specify 'throws' ->
        expect(-> pm {}, void).to.throw

    describe 'valid' ->
      specify 'is ok' ->
        expect(-> pm {}, {x: 2}).to.not.throw

  context 'valid MC' ->
    var pmatcher

    before ->
      ctx.article  :=
        subject:
          title: 'Hey ho!'
          _clazz: 'Article'

      ctx.compile  :=
        matches:
          match-on:
            includes:
              subject: ['Article']

        subject:
          title: 'Hey ho!'
          _clazz: 'Article'

      ar.article   :=
        subject: 'Article'

      ar.finger  :=
        subject: 'Article'
        fingerprint: ->
          'my ass xx'

      pmatcher := pm ctx.article, ar.article

    specify 'matchers are empty' ->
      pmatcher.matchers.should.eql {}

    specify 'match is by default true since matchers are by default disabled' ->
      pmatcher.match!.should.eql true

    specify 'Permit matchers are by default disabled' ->
      Permit.matchers-enabled.should.eql false

    describe 'matcher' ->
      var inc-matcher, key

      before ->
        key := 'includes'
        inc-matcher := pmatcher.matcher key

      specify 'is a ContextMatcher' ->
        inc-matcher.constructor.display-name.should.eql 'ContextMatcher'

      specify 'has context' ->
        inc-matcher.context.should.eql ctx.article

      specify 'has ar' ->
        inc-matcher.access-request.should.eql ar.article

      specify 'has key' ->
        inc-matcher.key.should.eql key

    context "they're not matching" ->
      var res
      describe.only 'match' ->
        before ->
          res := pmatcher.match!
          console.log res

        specify 'should not match' ->
          res.should.eql true

    context "they're matching" ->
      xdescribe 'match-compiled' ->
        var mc
        before-each ->
          pmatcher := pm ctx.compile, ar
          mc       := pmatcher.match-compiled!

        specify 'matches compiled' ->
          expect mc .to.eql true

      xdescribe 'include' ->
        var inc

        before-each ->
          pmatcher := pm ctx, ar
          inc      := pmatcher.include!

        specify 'matches include' ->
          expect inc .to.eql true

      xdescribe 'exclude' ->
        var excl

        before-each ->
          pmatcher := pm ctx, ar
          excl     := pmatcher.exclude!

        specify 'matches exclude' ->
          expect excl .to.eql true

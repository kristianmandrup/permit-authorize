requires  = require '../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

MatchingContext = requires.permit 'matcher' .MatchingContext

mc = (ctx, ar) ->
  new MatchingContext ctx, ar

describe 'MatchingContext' ->
  before ->

  describe 'create' ->
    describe 'invalid ar' ->
      specify 'throws' ->
        expect(-> mc {}, void).to.throw

    describe 'valid' ->
      specify 'is ok' ->
        expect(-> mc {}, void).to.not.throw

  context 'valid MC' ->
    var ctx, ar, arf, match-ctx

    before ->
      ctx  :=
        subject:
          title: 'Hey ho!'
          _clazz: 'Article'

      ar   :=
        subject: 'Article'

      arf  :=
        subject: 'Article'
        fingerprint: ->
          'my ass xx'

      match-ctx := mc ctx, ar

    context "they're matching" ->
      describe 'matching' ->
        specify 'should match' ->
          match-ctx.matching!.match-result.should.eql true

      describe '_access-matcher' ->
        var amc
        before ->
          amc := match-ctx._access-matcher(ar)

        specify 'is an AccessMatcher' ->
          expect amc.constructor.display-name .to.eql 'AccessMatcher'

        specify 'AccessMatcher with A.R' ->
          expect amc.access-request .to.eql ar

        specify 'has a match-result' ->
          expect amc.match-result .to.not.eql void

      describe '_cached-matchers' ->
        specify 'has no entries' ->
          cache = match-ctx._cached-matchers
          expect(cache).to.eql {}

    context "A.R with fingerprint" ->
      describe '_cached-matching' ->
        specify 'should match' ->
          res = match-ctx._cached-matching(arf)
          expect(res).to.not.eql void

        specify 'should cache in cached-matchers' ->
          cache = match-ctx._cached-matchers
          cached = cache[arf.fingerprint!]
          expect cached .to.not.eql void

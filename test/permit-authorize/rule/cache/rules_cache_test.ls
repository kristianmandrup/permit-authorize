requires  = require '../../../../requires'

requires.test 'test_setup'

Cache = requires.rule 'cache' .RulesCache

expect = require 'chai' .expect

User        = requires.fix 'user'

current-user = new User name: 'kris'

# create a cache for a user
create-cache = (obj) ->
  new Cache obj

describe 'RulesCache' ->
  var cache

  describe 'create(@object, @fp-class = FingerPrinter)' ->
    # @observe Permit.registry

    context 'invalid' ->
      specify 'throws' ->

    context 'valid' ->
      specify 'ok' ->

  context 'valid cache without object' ->
    before-each ->
      cache := create-cache!

    specify 'has object' ->
      expect cache.object .to.eql {}

    specify 'no-print is x' ->
      cache.no-print!.should.eql 'x'

    describe 'get' ->
      specify 'no x cached' ->
        expect cache.get 'x' .to.eql void

    describe 'set' ->
      var res

      before-each ->
        res := cache.set 'x', 'Y'

      specify 'returns cache' ->
        expect res .to.equal cache

      specify 'has x to Y' ->
        expect res.get 'x' .to.eql 'Y'

    describe 'init' ->
      before-each ->
        cache.init!

      specify 'fingerprint is set to x' ->
        cache.fingerprint.should.eql 'x'


  context 'valid cache with current-user' ->
    before-each ->
      cache := create-cache current-user

    specify 'has object' ->
      expect cache.object .to.equal current-user

    describe 'init' ->

    describe 'no-print' ->
      specify 'is void' ->
        expect cache.no-print! .to.eql void

    describe 'fingerprint' ->
      specify 'is not void' ->
        expect cache.fingerprint! .to.not.eql void

    describe 'fingerprinter' ->
      specify 'is a FingerPrinter' ->
        expect cache.fingerprinter!.constructor.display-name .to.eql 'FingerPrinter'

    describe 'observe(...targets)' ->
      context 'invalid target' ->
        specify 'doesnt throw when ' ->
          expect cache.observe({}) .to.not.throw

      context 'valid target' ->
        var target

        before-each ->
          target :=
            add-observer: (@observer) ->

          cache.observe target

        specify 'observes when valid target' ->
          expect target.observer .to.equal cache


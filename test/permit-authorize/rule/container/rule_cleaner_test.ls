requires  = require '../../../../requires'

requires.test 'test_setup'

Cleaner = requires.rule 'container' .RuleCleaner

expect = require 'chai' .expect

describe 'RuleCleaner' ->
  var repo, container, cleaner

  create-cleaner = (container, debug = true) ->
    new Cleaner container, debug

  repo =
    container:
      can: {}
      cannot: {}

  context 'basic repo' ->
    before ->
      cleaner := create-cleaner repo.container
      container := cleaner.container

    specify 'cleaner container is same as repo container' ->
      cleaner.container.should.equal repo.container

    describe 'clean' ->
      context 'has full can and cannot containers' ->
        before ->
          cleaner.container =
            can:
              edit: 'book'
            cannot:
              delete: 'article'

        describe ' - can' ->
          specify 'cleans can' ->
            cleaner.clean 'can'
            container.can.should.eql {}

        describe ' - cannot' ->
          specify 'cleans cannot' ->
            cleaner.clean 'cannot'
            container.cannot.should.eql {}

        describe 'clean-all' ->
          before ->
            cleaner.clean-all!

          specify 'cleans can' ->
            container.can.should.eql {}

          specify 'cleans cannot' ->
            container.cannot.should.eql {}



requires  = require '../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

RuleMatcher = require '../../../../rule' .RuleMatcher

create-matcher = (act, ar) ->
  new RuleMatcher act, ar

expect = require 'chai' .expect

describe 'RuleMatcher' ->
  subjects = {}
  ar       = {}

  describe 'create' ->
    context 'invalid' ->
      specify 'throws' ->
        expect( -> create-matcher 'can', {}).to.throw

    context 'valid' ->
      specify 'ok' ->
        expect( -> create-matcher 'can', {}).to.not.throw

      specify 'act is camel cased' ->
        create-matcher('can', {}).act.should.eql 'Act'

    context 'valid matcher' ->
      var matcher

      before ->
        subjects.book :=
          name: 'a nice journey'
          _class: 'Book'

        subjects.movie :=
          name: 'The Apollo moonlanding scam!'
          _class: 'Movie'
          type: 'documentary'

        ar.book :=
          user: 'kris'
          action: 'read'
          subject: subjects.book

        matcher := create-matcher 'can', ar.book

    describe 'manage-actions' ->
      specify 'has CED actions' ->
        matcher.manage-actions.should.eql ['create', 'edit', 'delete']

    describe 'container-for' ->

    describe 'rule-container' ->

    describe 'match-subject-clazz (action-subjects, subj-clazz)' ->

    describe 'match-manage-rule (rule-container, subj-clazz)' ->

    describe 'manage-action-subjects (rule-container)' ->

    describe 'match' ->



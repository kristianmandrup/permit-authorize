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
      specify 'creates container' ->
        matcher.container-for 'edit' .should

    describe 'rule-container' ->
      specify 'creates container' ->
        matcher.rule-container 'edit' .should

    describe 'match-subject-clazz (action-subjects, subj-clazz)' ->
      specify 'creates container' ->
        matcher.match-subject-clazz(['article', 'book', 'movie'], 'book').should.eql 'book'

    describe 'match-manage-rule (container, subj-clazz)' ->
      specify 'matches' ->
        matcher.match-subject-clazz({manage: ['book']}, 'book').should.eql 'edit'

    describe 'manage-action-subjects (rule-container)' ->
      specify 'manages' ->
        matcher.manage-action-subjects({manage: ['book']}).should.eql true

    describe 'match' ->
      specify 'matches' ->
        matcher.match!.should.eql true



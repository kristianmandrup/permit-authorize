requires  = require '../../../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

Matcher = requires.rule 'container' .matcher.RuleMatcher

create-matcher = (container, act, ar, debug = true) ->
  new Matcher container, act, ar, debug

expect = require 'chai' .expect

describe 'RuleMatcher' ->
  subjects    = {}
  ar          = {}
  containers  = {}

  var matcher

  subjects.book :=
    name: 'a nice journey'
    _class: 'Book'

  subjects.movie :=
    name: 'The Apollo moonlanding scam!'
    _class: 'Movie'
    type: 'documentary'

  ar.book :=
    user: 'kris'
    action: 'edit'
    subject: subjects.book

  containers.managed-book =
    can:
      manage: ['book', 'blog']
      write:  ['journal', 'article']
      edit:   ['movie']

  containers.unmanaged-book =
    can:
      edit:   ['book', 'blog']
      create: ['article']
      write:  ['journal', 'article']

  describe 'create' ->
    context 'invalid' ->
      specify 'throws' ->
        expect( -> create-matcher {}, 'can', void).to.throw

    context 'valid' ->
      specify 'ok' ->
        expect( -> create-matcher containers.managed-book, 'can', {}).to.not.throw

      specify 'act is set' ->
        create-matcher(containers.managed-book, 'can', {}).act.should.eql 'can'

  context 'valid matcher' ->
    before-each ->
      matcher := create-matcher containers.managed-book, 'can', ar.book

    describe 'manage-actions' ->
      specify 'has CED actions' ->
        matcher.manage-actions.should.eql ['create', 'edit', 'delete']

    describe 'match-subject' ->
      specify 'edit does not match' ->
        matcher.match-subject!.should.eql false

    describe 'subject-matcher' ->
      specify 'is void' ->
        expect matcher.subject-matcher! .to.not.eql void

    describe 'action-subjects' ->
      specify 'is void' ->
        expect matcher.action-subjects! .to.not.eql void

    describe 'act-container' ->
      specify 'has subjects' ->
        matcher.act-container!.should.eql {
          manage: ['book', 'blog']
          write:  ['journal', 'article']
          edit:   ['movie']
        }

  context 'unmanaged book' ->
    before-each ->
      matcher := create-matcher containers.unmanaged-book, 'can', ar.book

    describe 'managed-subject-matcher' ->
      specify 'is void' ->
        expect matcher.managed-subject-matcher! .to.not.eql void

    describe 'managed-subject-match' ->
      specify 'matches' ->
        matcher.managed-subject-match!.should.eql false

    describe 'action-subjects' ->
      specify 'matches' ->
        expect matcher.action-subjects! .to.eql ['book', 'blog']

    describe 'match-subject' ->
      specify 'matches' ->
        matcher.match-subject!.should.eql true

    describe 'subject-matcher' ->
      specify 'matches' ->
        expect matcher.subject-matcher! .to.not.eql void

    describe 'match' ->
      specify 'matches' ->
        matcher.match!.should.eql true


  context 'managed book' ->
    before-each ->
      matcher := create-matcher containers.managed-book, 'can', ar.book

    describe 'managed-subject-matcher' ->
      specify 'is void' ->
        expect matcher.managed-subject-matcher! .to.not.eql void

    describe 'action' ->
      specify 'is edit, not manage' ->
        matcher.action.should.eql 'edit'

    describe 'managed-subject-match' ->
      specify 'matches' ->
        matcher.managed-subject-match!.should.eql true

    describe 'match' ->
      specify 'matches' ->
        matcher.match!.should.eql false

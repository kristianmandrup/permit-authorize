requires  = require '../../../../../requires'

requires.test 'test_setup'

Matcher = requires.rule 'container' .matcher.ManagedSubjectMatcher

expect = require 'chai' .expect

containers = {}

log = console.log

describe 'ManagedSubjectMatcher' ->
  var matcher

  create-matcher = (container, debug = false) ->
    new Matcher container, debug

  containers.managed-book =
      manage: ['book']

  containers.none-managed =
      edit: ['book']
      create: ['article']

  describe 'create' ->
    describe 'invalid' ->
      specify 'throws' ->
        expect -> create-matcher void .to.throw

    describe 'valid' ->
      specify 'ok' ->
        expect -> create-matcher [] .to.not.throw

  context 'created' ->
    before-each ->
      matcher := create-matcher 'book'

    describe 'match(subject)' ->
      specify 'calling with void does not match' ->
        expect matcher.match! .to.eql false

    context 'book is managed' ->
      before-each ->
        matcher := create-matcher containers.managed-book

      describe 'is-managed (subject)' ->
        specify 'no match' ->
          expect matcher.match 'book' .to.eql false

      describe 'managed-subjects' ->
        # @_manage-subjects ||= @container['manage']
        specify 'returns list' ->
          expect matcher.managed-subjects! .to.eql ['book']

      describe 'match-subject (subject)' ->
        # @subject-matcher subjects, subject .match subject
        specify 'matches' ->
          expect matcher.match-subject('book').to.eql true

      describe 'subject-matcher' ->
        # new ManagedSubjectMatcher subjects
        specify 'returns matcher' ->
          expect matcher.subject-matcher!.subjects .to.eql ['book']

      describe 'manage-action-subjects' ->

    context 'book is not managed' ->
      before-each ->
        matcher := create-matcher containers.none-managed

      describe 'is-managed (subject)' ->
        specify 'matches' ->
          expect matcher.match 'book' .to.eql false

      describe 'managed-subjects' ->
        # @_manage-subjects ||= @container['manage']
          specify 'returns empty' ->
            expect matcher.managed-subjects! .to.eql []

      describe 'match-subject (subject, subjects)' ->
        # @subject-matcher subjects, subject .match subject
        specify 'returns empty' ->
          expect matcher.match-subject('book') .to.eql false

      describe.only 'subject-matcher (subjects)' ->
        # new ManagedSubjectMatcher subjects
        specify 'returns empty' ->
          expect matcher.subject-matcher!.subjects .to.eql []

      describe 'manage-action-subjects' ->
        specify 'returns list for edit' ->
          expect matcher.manage-action-subjects!.0 .to.eql ['article']





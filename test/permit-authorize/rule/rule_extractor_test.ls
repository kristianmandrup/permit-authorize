requires  = require '../../../requires'

requires.test 'test_setup'

User        = requires.fix 'user'
Book        = requires.fix 'book'

RepoExtractor   = requires.lib 'rule' .RepoExtractor

expect = require 'chai' .expect

describe 'RepoRegistrator' ->
  var access-request, rule, repo
  var book
  var can, cannot

  create-extr = (container, action, subjects) ->
    new RepoExtractor container, action, subjects

  describe 'create' ->
    describe 'invalid' ->
      specify 'throws' ->
        expect( -> create-extr {}, 'ax').to.throw

    describe 'valid' ->

  context 'valid extractor' ->
    before ->
      repo := create-repo 'my repo'

requires  = require '../../../../requires'

requires.test 'test_setup'

User          = requires.fix 'user'
Book          = requires.fix 'book'

RulesApplier      = requires.rule 'apply' .DynamicApplier
RuleRepo          = requires.rule 'repo'  .RuleRepo
ExecutionContext  = requires.rule 'apply' .ExecutionContext

expect = require 'chai' .expect

# Note: Use rule-repo.display! for debugging internals of RuleRepo instances after rule application

describe 'Rule Applier (RuleApplier)' ->
  var book
  var repo
  var rule-applier

  rules   = {}
  requests = {}
  ctx = {}
  obj = {}

  create-repo = ->
    new RuleRepo('static repo').clear!

  create-repo = (name = 'dynamic repo', debug = false) ->
    new RuleRepo name, debug .clean!

  create-exec-ctx = (debug = true) ->
    new ExecutionContext create-repo!, debug

  create-rules-applier = (rules, access-request, debug = true) ->
    new RulesApplier create-exec-ctx!, rules, access-request, debug

  exec-rule-applier = (rules, action-request) ->
    create-rules-applier(rules, action-request).apply-rules!

  before-each ->
    book          := new Book 'Far and away'

  rules.manage-paper :=
    area: ->
      @ucan    'manage',   'Paper'

    admin:
      domain: ->
        @ucan    'manage',   'Paper'

  requests.read-book :=
    action: 'read'
    subject: book

  rule-applier := create-rules-applier rules.manage-paper, requests.read-book

  describe 'apply-rules-for' ->
    before-each ->
      rule-applier.apply-rules-for 'area'
      repo := rule-applier.repo!

    specify 'should apply the area rule' ->
      expect repo.can-rules!.manage .to.eql [ 'Paper' ]

  describe 'context-rules' ->
    before-each ->
      ctx.area  := rule-applier.context-rules 'area'
      ctx.admin := rule-applier.context-rules 'admin'

      rule-applier.context-rules 'admin'

    specify 'should return itself (area) since it is a Function and no more keys underneath' ->
      expect Object.keys(ctx.area) .to.eql ['area', 'admin']

    specify 'should return Object it points to' ->
      expect Object.keys(ctx.admin) .to.eql ['domain']

  describe 'apply-obj-rules-for' ->
    before ->
      obj.area  :=
        edit: 'book'

      obj.admin :=
        admin: 'movie'

    context 'object' ->
      before-each ->
        rule-applier.apply-obj-rules-for obj, 'area'
        repo := rule-applier.repo!

      specify 'should return manage Paper' ->
        expect repo.can-rules!.manage .to.eql ['Paper']

    context 'area - edit' ->
      before-each ->
        rule-applier.apply-obj-rules-for obj.area, 'edit'
        repo := rule-applier.repo!

      specify 'should return manage Paper' ->
        expect repo.can-rules!.manage .to.eql ['Paper']

  describe 'apply-all-rules' ->
    before-each ->
      rule-applier.apply-all-rules!
      repo := rule-applier.repo!

    specify 'should return manage Paper' ->
      expect repo.can-rules!.manage .to.eql ['Paper']


  xcontext 'full scenarios' ->
    # can create, edit and delete a Book
    describe 'manage paper' ->
      context 'applied default rule: manage Paper' ->
        before ->
          rules.manage-paper :=
            default: ->
              @ucan    'manage',   'Paper'

          rule-applier := create-rules-applier rules.manage-paper, requests.read-book
          repo := rule-applier.repo!

        specify 'should add create, edit and delete can-rules' ->
          repo.can-rules!.should.eql {
            manage: ['Paper']
            create: ['Paper']
            edit:   ['Paper']
            delete: ['Paper']
          }
#
#      context 'applied action rule: manage Book' ->
#        var manage-book-request
#
#        before ->
#          manage-book-request :=
#            action: 'manage'
#
#          rules.manage-book :=
#            manage: ->
#              @ucan    'manage',   'Book'
#
#          create-rule-applier(rules.manage-book, manage-book-request).apply-action-rules 'manage'
#
#        specify 'should add create, edit and delete can-rules' ->
#          rule-repo.can-rules.should.eql {
#            manage: ['Book']
#            create: ['Book']
#            edit:   ['Book']
#            delete: ['Book']
#          }
#
#
#    # can read any subject
#    describe 'read any' ->
#      context 'applied default rule: read any' ->
#        before ->
#          rules.read-any :=
#            default: ->
#              @ucan    'read',   'any'
#
#          exec-rule-applier rules.read-any
#
#        specify 'should add can-rule: read *' ->
#          rule-repo.can-rules.should.eql {
#            read: ['*']
#          }
#
#    # can read any subject
#    describe 'read *' ->
#      context 'applied default rule: read any' ->
#        var read-rules
#
#        before ->
#          rules.read-star :=
#            default: ->
#              @ucan    'read',   '*'
#
#          exec-rule-applier rules.read-star
#
#        specify 'should add can-rule: read *' ->
#          rule-repo.can-rules.should.eql {
#            read: ['*']
#          }
#
#    # can create, edit and delete any subject
#    describe 'manage any' ->
#      context 'applied default rule: manage any' ->
#        var manage-rules
#
#        before ->
#          rules.manage-any :=
#            default: ->
#              @ucan    'manage',   'any'
#
#          exec-rule-applier rules.manage-any
#
#        specify 'should add can-rule: manage *' ->
#          rule-repo.can-rules.should.eql {
#            manage: ['*']
#            create: ['*']
#            edit:   ['*']
#            delete: ['*']
#          }
#
#    # can create, edit and delete any subject
#    describe 'ensure merge and not override of registered rules' ->
#      context 'applied default rule: manage any and edit Paper' ->
#        var manage-rules
#
#        before ->
#          rules.manage-any :=
#            default: ->
#              @ucan    'manage',   'any'
#              @ucan    'edit',     'Paper'
#
#          exec-rule-applier rules.manage-any
#
#        specify 'should merge rules for edit: *, Paper' ->
#          rule-repo.can-rules.edit.should.eql ['*', 'Paper']
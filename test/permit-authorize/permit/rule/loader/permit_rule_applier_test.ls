requires        = require '../../../requires'

requires.test 'test_setup'

Permit          = requires.lib 'permit'
PermitRegistry  = requires.permit 'permit-registry'

Book            = requires.fix 'book'
permit-clazz    = requires.fix 'permit-class'

create-permit   = requires.fac 'create-permit'
create-user     = requires.fac 'create-user'

AdminPermit     = permit-clazz.AdminPermit
GuestPermit     = permit-clazz.GuestPermit

describe 'Permit' ->
  var book
  requests  =
    admin: {}
    kris:  {}
  permits   = {}
  users     = {}

  before ->
    book := new Book 'a book'
    requests.admin.read-book :=
      user:
        role: 'admin'
      action: 'read'
      subject: book
      ctx:
        area: 'visitor'

    users.kris = create-user.kris!

    requests.kris.read-paper :=
      user: users.kris
      action: 'read'
      subject: 'paper'
      ctx:
        area: 'visitor'


  describe 'Rules application' ->
    # auto applies static rules by default (in init) as part of construction!
    describe 'static rules application' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.guest!

      after ->
        PermitRegistry.clear-all!

      specify 'registers a read-any rule (using default)' ->
        permits.guest.can-rules!['read'].should.eql ['*']

    describe 'dynamic rules application - user rules' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.admin!

        # dynamic application when access-request passed
        rule-applier = permits.guest.rule-applier requests.kris.read-paper
        # rule-applier.debug-on!
        # console.log 'Kris', users.kris

        rule-applier.apply-user-rules users.kris

      after ->
        PermitRegistry.clear-all!

      specify 'registers a manage User rule' ->
        permits.guest.can-rules!['manage'].should.include 'User'

    describe 'dynamic rules application - action rules' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        rule-applier = permits.guest.rule-applier requests.admin.read-book

        rule-applier.apply-action-rules 'read'

      after ->
        PermitRegistry.clear-all!

      specify 'registers a read Book rule' ->
        permits.guest.can-rules!['read'].should.include 'Book'

    describe 'dynamic rules application - ctx rules' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        rule-applier = permits.guest.rule-applier requests.admin.read-book

        rule-applier.apply-context-rules area: 'visitor'

      after ->
        PermitRegistry.clear-all!

      specify 'registers a publish Paper rule' ->
        permits.guest.can-rules!['publish'].should.include 'Paper'

    describe 'dynamic rules application - subject rules - class' ->
      before ->
        permits := {}
        PermitRegistry.clear-all!
        permits.admin := create-permit.admin!

        # dynamic application when access-request passed
        rule-applier = permits.admin.rule-applier requests.kris.read-paper

        rule-applier.apply-subject-rules 'Paper'

      after ->
        PermitRegistry.clear-all!

      specify 'registers an approve Paper rule' ->
        permits.admin.can-rules!['approve'].should.include 'Paper'

    describe 'dynamic rules application - subject rules - instance to class' ->
      before ->
        class Paper
          (@name) ->

        paper = new Paper title: 'a paper'

        permits := {}
        PermitRegistry.clear-all!
        permits.admin := create-permit.admin!

        # dynamic application when access-request passed
        rule-applier = permits.admin.rule-applier requests.kris.read-paper
        # rule-applier.debug-on!

        rule-applier.apply-subject-rules paper

      after ->
        PermitRegistry.clear-all!

      specify 'registers an approve Paper rule' ->
        permits.admin.can-rules!['approve'].should.include 'Paper'


    describe 'dynamic rules application' ->
      before ->
        PermitRegistry.clear-all!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        permits.guest.apply-rules requests.admin.read-book, 'force'

      after ->
        PermitRegistry.clear-all!

      specify 'registers a read-book rule' ->
        permits.guest.can-rules!['read'].should.include 'Book'

      specify 'does NOT register a write-book rule' ->
        ( -> permits.guest.can-rules!['write'].should).should.throw

      context 'dynamic rules applied twice' ->
        before ->
          permits.guest := create-permit.guest!

          # dynamic application when access-request passed
          permits.guest.apply-rules requests.admin.read-book

        after ->
          PermitRegistry.clear-all!

          # dynamic application when access-request passed
          permits.guest.apply-rules requests.admin.read-book
          permits.guest.apply-rules requests.admin.read-book

          specify 'still registers only a SINGLE read-book rule' ->
            permits.guest.can-rules!['read'].should.eql ['Book']

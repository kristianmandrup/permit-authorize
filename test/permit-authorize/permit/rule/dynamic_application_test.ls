requires  = require '../../../../requires'

requires.test 'test_setup'

Permit          = requires.lib    'permit'    .Permit
PermitRegistry  = requires.permit 'registry'  .PermitRegistry

Book            = requires.fix 'book'
permit-clazz    = requires.fix 'permit-class'

create-permit   = requires.fac 'create-permit'
create-user     = requires.fac 'create-user'

AdminPermit     = permit-clazz.AdminPermit
GuestPermit     = permit-clazz.GuestPermit

describe 'Permit' ->
  var book, applier
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

    describe 'dynamic rules application - user rules' ->
      before-each ->
        Permit.registry.clean!
        permits.guest := create-permit.admin!

        # dynamic application when access-request passed
        applier = permits.guest.applier requests.kris.read-paper
        # rule-applier.debug-on!
        # console.log 'Kris', users.kris

        applier.apply-user-rules users.kris

      specify 'registers a manage User rule' ->
        permits.guest.can-rules!['manage'].should.include 'User'

    describe 'dynamic rules application - action rules' ->
      before-each ->
        Permit.registry.clean!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        applier := permits.guest.applier requests.admin.read-book

        applier.apply-action-rules 'read'

      specify 'registers a read Book rule' ->
        permits.guest.can-rules!['read'].should.include 'Book'

    describe 'dynamic rules application - ctx rules' ->
      before-each ->
        Permit.registry.clean!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        applier := permits.guest.applier requests.admin.read-book

        applier.apply-context-rules area: 'visitor'

      specify 'registers a publish Paper rule' ->
        permits.guest.can-rules!['publish'].should.include 'Paper'

    describe 'dynamic rules application - subject rules - class' ->
      before-each ->
        permits := {}
        Permit.registry.clean!
        permits.admin := create-permit.admin!

        # dynamic application when access-request passed
        applier := permits.admin.applier requests.kris.read-paper

        applier.apply-subject-rules 'Paper'

      specify 'registers an approve Paper rule' ->
        permits.admin.can-rules!['approve'].should.include 'Paper'

    describe 'dynamic rules application - subject rules - instance to class' ->
      before-each ->
        class Paper
          (@name) ->

        paper = new Paper title: 'a paper'

        permits := {}
        Permit.registry.clean!
        permits.admin := create-permit.admin!

        # dynamic application when access-request passed
        applier := permits.admin.applier requests.kris.read-paper
        # rule-applier.debug-on!

        applier.apply-subject-rules paper

      specify 'registers an approve Paper rule' ->
        permits.admin.can-rules!['approve'].should.include 'Paper'


    describe 'dynamic rules application' ->
      before-each ->
        Permit.registry.clean!
        permits.guest := create-permit.guest!

        # dynamic application when access-request passed
        permits.guest.apply-rules requests.admin.read-book, 'force'

      specify 'registers a read-book rule' ->
        permits.guest.can-rules!['read'].should.include 'Book'

      specify 'does NOT register a write-book rule' ->
        ( -> permits.guest.can-rules!['write'].should).should.throw

      context 'dynamic rules applied twice' ->
        before-each ->
          Permit.registry.clean!
          permits.guest := create-permit.guest!

          # dynamic application when access-request passed
          permits.guest.apply-rules requests.admin.read-book

          # dynamic application when access-request passed
          permits.guest.apply-rules requests.admin.read-book
          permits.guest.apply-rules requests.admin.read-book

          specify 'still registers only a SINGLE read-book rule' ->
            permits.guest.can-rules!['read'].should.eql ['Book']
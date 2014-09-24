# TODO: Yeah!

requires  = require '../../../../requires'

requires.test 'test_setup'

PermitContainer = requires.permit 'container' .PermitContainer

expect = require 'chai' .expect

describe 'PermitContainer' ->
  permits = {}
  containers = {}

  before ->

  describe 'create container' ->
    context 'no name' ->
      specify 'must have a name' ->
        expect(-> new PermitContainer).to.throw

    context 'has name' ->
      specify 'fine - description is optional' ->
        expect(-> new PermitContainer 'xyz').to.not.throw
        new PermitContainer 'xyz' .name.should.eql 'xyz'

    context 'has name and description' ->
      specify '.description set' ->
        new PermitContainer 'xyz', 'my desc' .description.should.eql 'my desc'

  context 'named container' ->
    var permit, container, pname, cname

    create-container = (name, desc) ->
      new PermitContainer name, desc

    before ->
      pname := 'my permit'
      cname := 'my container'
      permit :=
        name: pname

      container := create-container cname, 'my desc'

    describe 'add' ->
      specify 'adds permit to repo key for name of permit' ->
        container.add permit .repo[pname].should.eql permit

    describe 'remove' ->
      specify 'removes existing key' ->
        container.add permit
        res = container.remove pname
        expect res.repo[pname] .to.eql void

      specify 'removes non-existing key fails' ->
        container.add permit
        expect(-> container.remove 'blip').to.throw
        expect container.repo[pname] .to.not.eql void

    describe 'activate' ->
      before-each ->
        container.activate!

      specify 'activates container' ->
        expect(container.active).to.be.true

      specify 'adds itself to active containers' ->
        PermitContainer.active-containers[cname].should.equal container

    describe 'deactivate' ->
      before-each ->
        container.deactivate!

      specify 'activates container' ->
        expect(container.active).to.be.false

      specify 'adds itself to active containers' ->
        expect(PermitContainer.active-containers[cname]).to.eql void

    context 'activated 2 containers' ->
      before-each ->
        container.activate!
        create-container 'x', 'y' .activate!

      describe 'active-containers-permits' ->
        specify 'returns list w 2 elems' ->
          expect PermitContainer.active-containers-list!.length .to.equal 2

      describe 'has-any' ->
        specify 'yes' ->
          expect PermitContainer.has-any! .to.be.true

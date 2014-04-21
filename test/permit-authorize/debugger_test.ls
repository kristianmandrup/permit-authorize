requires  = require '../../requires'

requires.test 'test_setup'

lo            = requires.util 'lodash-lite'
Debugger      = requires.lib 'debugger'

class TestDebug implements Debugger
  ->
    super

  @clazz-meth = ->
    @debug "clazz-meth", "called"

  inst-meth: ->
    @debug "inst-meth", "called"

# extend TestDebug class methods with Debugger
lo.extend TestDebug, Debugger

describe 'Debugger' ->
  describe 'class level' ->
    describe 'defaults' ->
      specify 'debugging should be off' ->
        TestDebug.debugging.should.eql false

    describe 'debug-on' ->
      before ->
        TestDebug.debug-on!

      specify 'debugging should be on' ->
        TestDebug.debugging.should.eql true

    describe 'debug-off' ->
      before ->
        TestDebug.debug-on!
        TestDebug.debug-off!

      specify 'debugging should be on' ->
        TestDebug.debugging.should.eql false

    describe 'debug' ->
      context 'debugging off' ->
        specify 'does NOT prints a msg to console' ->
          TestDebug.debug 'not', 'printed'

      context 'debugging on' ->
        before ->
          TestDebug.debug-on!

        specify 'prints a msg to console' ->
          TestDebug.debug 'is', 'printed'


  describe 'instance level' ->
    var test-debug

    before ->
      test-debug := new TestDebug

    describe 'defaults' ->
      specify 'debugging should be off' ->
        test-debug.debugging.should.eql false

    describe 'debug-on' ->
      before ->
        test-debug.debug-on!

      specify 'debugging should be on' ->
        test-debug.debugging.should.eql true

    describe 'debug-off' ->
      before ->
        test-debug.debug-on!
        test-debug.debug-off!

      specify 'debugging should be on' ->
        test-debug.debugging.should.eql false

    describe 'debug' ->
      context 'debugging off' ->
        specify 'does NOT prints a msg to console' ->
          test-debug.debug 'not', 'printed'

      context 'debugging on' ->
        before ->
          test-debug.debug-on!

        specify 'prints a msg to console' ->
          test-debug.debug 'is', 'printed'
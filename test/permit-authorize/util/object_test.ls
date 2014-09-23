requires  = require '../../../requires'

requires.test 'test_setup'

object        = requires.util 'object'
Debugger      = requires.util 'debugger'

describe 'util' ->
  describe 'object' ->
    describe 'values' ->
      specify 'should create unique array' ->
        object.values a: 'x', b: 'y' .should.eql ['x','y']


requires  = require '../../../requires'

requires.test 'test_setup'

array         = requires.util 'array'
Debugger      = requires.util 'debugger'

describe 'util' ->
  describe 'array' ->
    describe 'unique' ->
      specify 'should create unique array' ->
        array.unique [1,2,1,3,2] .should.eql [1,3,2]

    describe 'contains' ->
      specify 'should find matching elem' ->
        array.contains([1,2,1,'x',2], 'x').should.eql true

    describe 'flatten' ->
      specify 'should flatten array' ->
        array.flatten([1,2,[1,3],2]) .should.eql [1,2,1,3,2]

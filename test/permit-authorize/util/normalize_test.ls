requires  = require '../../../requires'

requires.test 'test_setup'
User      = requires.fix  'user'
normalize = requires.util 'normalize'

describe 'normalize' ->
  var fun, str, list, fun-list, nested-fun

  before ->
    fun := ->
      ["xyz"]
    str := "abc"
    list := ['a', 'b']

    fun-list := ["abc", fun]

    nested-fun := ->
      fun-list

  describe 'Function' ->
    specify 'is called' ->
      normalize(fun).should.eql ["xyz"]

  describe 'String' ->
    specify 'wrapped in array' ->
      normalize(str).should.eql [str]

  describe 'Array' ->
    specify 'returned' ->
      normalize(list).should.eql list

  describe 'Array with function' ->
    specify 'normalize function' ->
      normalize(fun-list).should.eql ["abc", "xyz"]

  describe 'Number' ->
    specify 'throws error' ->
      (->
        normalize(3)
      ).should.throw!

  describe 'Nested Functions' ->
    specify 'normalized to single array' ->
      normalize(nested-fun).should.eql ["abc", "xyz"]

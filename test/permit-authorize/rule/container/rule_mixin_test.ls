requires  = require '../../../../requires'

requires.test 'test_setup'

mixin       = requires.rule 'container' .RuleMixin

expect = require 'chai' .expect

describe 'RuleMixin' ->
  var container, act, action

  context 'basic repo' ->
    before ->
      container := {}

      act       := 'can'
      action    := 'edit'

    describe 'valid-container' ->
      context 'empty container' ->
        specify 'throws' ->
          expect mixin.valid-container(container, 'can') .to.throw

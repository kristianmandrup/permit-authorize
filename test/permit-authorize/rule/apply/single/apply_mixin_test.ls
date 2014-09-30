requires  = require '../../../../../requires'

requires.test 'test_setup'

expect = require 'chai' .expect

ApplyMixin = requires.rule 'apply' .single.ApplyMixin

class Invalid implements ApplyMixin
  ->
    # nothing

class Rules implements ApplyMixin
  (@rules = {}) ->

describe 'ApplyMixin' ->
  var mixer

  context 'no @rules' ->
    before ->
      mixer := new Invalid

    specify 'throws' ->
      expect mixer.context-rules 'user' .to.throw

  context 'has @rules' ->
    before ->
      mixer := new Rules

    specify 'ok' ->
      expect mixer.context-rules 'user' .to.not.throw

    describe 'context-rules' ->

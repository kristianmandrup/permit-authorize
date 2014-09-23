ObjectFingerprint = require './object_fingerprint'
ArrayFingerprint  = require './array_fingerprint'

module.exports =
  access-hash: ->
    @_access-hash ||= [@action-hash!, @subject-hash!, @ctx-hash!].join ':'

  subject-hash: ->
    @subject-fingerprint ||= new ObjectFingerprint @subject .fingerprint!

  action-hash: ->
    @action-fingerprint ||= new ArrayFingerprint @action .fingerprint!

  user-hash: ->
    @user-fingerprint ||= new ObjectFingerprint @user .fingerprint!

  ctx-hash: ->
    @ctx-fingerprint ||= new ObjectFingerprint @ctx .fingerprint!

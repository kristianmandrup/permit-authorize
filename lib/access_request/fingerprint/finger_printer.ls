ObjectFingerprint = require './object_fingerprint'
ArrayFingerprint  = require './array_fingerprint'
join = require '../../util' .array.join

module.exports = class FingerPrinter
  (@ar) ->

  fingerprint: ->
    @access-hash!

  access-hash: ->
    @_access-hash ||= [@action-hash!, @subject-hash!, @ctx-hash!].join ':'

  subject-hash: ->
    @subject-fingerprint ||= new ObjectFingerprint @ar.subject .fingerprint!

  action-hash: ->
    @action-fingerprint ||= new ArrayFingerprint @ar.action .fingerprint!

  user-hash: ->
    @user-fingerprint ||= new ObjectFingerprint @ar.user .fingerprint!

  ctx-hash: ->
    @ctx-fingerprint ||= new ObjectFingerprint @ar.ctx .fingerprint!

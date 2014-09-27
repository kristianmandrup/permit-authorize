ObjectFingerprint = require './object_fingerprint'
ArrayFingerprint  = require './array_fingerprint'
util = require '../../util'
join = util.array.join

md5  = require '../util' .md5

module.exports = class FingerPrinter
  (@ar) ->

  fingerprint: ->
    @_fingerprint ||= md5 @access-hash!

  hash: ->
    @fingerprint!

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

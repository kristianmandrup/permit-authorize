class Fingerprint
  (@value) ->
    @

  fingerprint: ->
    @none! or @string!

  string: ->
    @value if typeof! @value is 'String'

  none: ->
    'x' if @value is void

class ObjectFingerprint extends Fingerprint
  fingerprint: ->
    super! or @hash! or @json!

  hash: ->
    @value.hash! if typeof! @value.hash is 'Function'

  json: ->
    JSON.stringify @value

class ArrayFingerprint extends Fingerprint
  fingerprint: ->
    @none! or @string! or @joined!

  joined: ->
    @value.join '.' if typeof! @value is 'Array'

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

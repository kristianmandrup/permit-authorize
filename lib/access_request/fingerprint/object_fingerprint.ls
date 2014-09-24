Fingerprint = require './fingerprint'

module.exports = class ObjectFingerprint extends Fingerprint
  fingerprint: ->
    super! or @hash! or @own-fingerprint! or @json!

  hash: ->
    @value.hash! if typeof! @value.hash is 'Function'

  own-fingerprint: ->
    @value.fingerprint! if typeof! @value.fingerprint is 'Function'

  json: ->
    JSON.stringify @value

Fingerprint = require './fingerprint'

module.exports = class ObjectFingerprint extends Fingerprint
  fingerprint: ->
    super! or @hash! or @json!

  hash: ->
    @value.hash! if typeof! @value.hash is 'Function'

  json: ->
    JSON.stringify @value

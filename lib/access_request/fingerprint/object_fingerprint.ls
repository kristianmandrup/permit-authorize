Fingerprint = require './fingerprint'

module.exports = class ObjectFingerprint extends Fingerprint
  fingerprint: ->
    super! or @hash! or @own-fingerprint! or @get-fingerprint! or @json!

  hash: ->
    @value.hash! if typeof! @value.hash is 'Function'

  own-fingerprint: ->
    @value.fingerprint! if typeof! @value.fingerprint is 'Function'

  # support Ember Object getters!
  get-fingerprint: ->
    @value.get('fingerprint')! if @value.get is 'Function'


  json: ->
    JSON.stringify @value

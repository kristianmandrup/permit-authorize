Fingerprint = require './fingerprint'

module.exports = class ArrayFingerprint extends Fingerprint
  fingerprint: ->
    @none! or @string! or @joined!

  joined: ->
    @value.join '.' if typeof! @value is 'Array'

FingerPrinter = require '../../access_request' .fingerprint.FingerPrinter
Debugger      = require '../../util' .Debugger

module.exports = class RulesCache implements Debugger
  (@object, @fp-class = FingerPrinter) ->

  # should be cleared whenever a new permit is added and activated.
  clear-cache: ->
    @can = {}
    @cannot = {}

  can-cache: ->
    @can ||= {}

  cannot-cache: ->
    @cannot ||= {}

  fingerprint: ->
    @_fingerprint ||= @fingerprinter!.hash!

  fingerprinter: ->
    new @fp-class @object

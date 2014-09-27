FingerPrinter = require '../../access_request' .fingerprint.FingerPrinter
Debugger      = require '../../util'    .Debugger
Permit        = require '../../permit'  .Permit

module.exports = class RulesCache implements Debugger
  (@object = {}, @fp-class = FingerPrinter) ->
    @clear-cache!

  init: ->
    @observe Permit.registry
    @fingerprint!

  # should be cleared whenever a new permit is added and activated.
  clear-cache: ->
    @cache = {}

  get: (name) ->
    @cache[name]

  set: (name, value) ->
    @cache[name] = value
    @

  # can be used where multiple caches are needed...
  # overrides self with value :)
  # TODO: should use this pattern much more
  fingerprint: ->
    @fingerprint = @no-print! or @fingerprinter!.fingerprint!

  no-print: ->
    'x' if Object.keys @object .length == 0

  fingerprinter: ->
    new @fp-class @object

  observe: (...targets) ->
    for target in targets
      target.add-observer @ if typeof! target?add-observer is 'Function'

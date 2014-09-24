Debugger = require '../../../util' .Debugger

module.exports = class MatchCompiler implements Debugger
  (@context) ->
    unless typeof! @context is 'Object'
      throw new Error "MatchCompiler expects an Object as the context"

  compile: (@type, @match) ->
    @debug "compile", @type, @match

    context = @context

    # the resulting matching function added to permit.compiled-list
    (access-request) ->
      match-obj = {(type): @match}
      context.match-on access-request, match-obj

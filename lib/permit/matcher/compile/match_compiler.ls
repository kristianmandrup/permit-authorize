Debugger = require '../../../util' .Debugger

module.exports = class MatchCompiler implements Debugger
  (@context) ->

  compile: (@type, @match) ->
    @debug "compile", @type, @match

    context = @context

    # the resulting matching function added to permit.compiled-list
    (access-request) ->
      match-obj = {(type): @match}
      self.debug 'compiled fun: match-on', access-request
      context.match-on access-request, match-obj

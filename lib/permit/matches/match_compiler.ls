module.exports = class MatchCompiler
  (@permit) ->

  compile: (@type, @match) ->
    @debug "compile", @type, @match

    permit = @permit

    # the resulting matching function added to permit.compiled-list
    (access-request) ->
      match-obj = {(type): @match}
      self.debug 'compiled fun: match-on', access-request
      permit.match-on access-request, match-obj

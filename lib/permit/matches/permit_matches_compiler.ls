module.exports = class PermitMatchesCompiler
  (@permit) ->

  compile-matchers: ->
    @debug "compile-matchers", @matches-on
    return unless typeof! @matches-on is 'Object'

    @compiled-list = []
    @debug "compile..."
    # Compiles the matches object of a permit
    for key of @matches-on
      @matches-processor!.process key, @matches-on[key]

    @debug 'compiled matchers:', @compiled-list

  matches-processor: ->
    @_matches-processor ||= new MatchesProcessor @



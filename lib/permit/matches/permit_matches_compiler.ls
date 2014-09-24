Debugger        = require '../../util' .Debugger

module.exports = class PermitMatchesCompiler implements Debugger
  (@permit, @debugging) ->

  compile-matchers: ->
    @debug "compile-matchers", @matches-on
    return unless typeof! @matches-on is 'Object'

    @compiled-list = []
    @debug "compile..."
    # Compiles the matches object of a permit
    for key of @matches-on
      @matches-processor!.process key, @matches-on[key]

    @debug 'compiled matchers:', @compiled-list

  matches-compiler: ->
    MatchesCompiler = require './matches_compiler'
    @_matches-compiler ||= new MatchesCompiler @permit



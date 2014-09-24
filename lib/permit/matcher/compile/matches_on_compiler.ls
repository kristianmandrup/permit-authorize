Debugger        = require '../../../util' .Debugger
MatchesCompiler = require './matches_compiler'

# Takes the context of the form

# matches-on:
#   roles: ['publisher', 'editor']
#   action: 'read'

# then compiles it into an AccessMatcher.match-on(...) statement

module.exports = class MatchesOnCompiler implements Debugger
  (@context, @debugging) ->

  compile-matchers: ->
    @debug "compile-matchers", @matches-on
    return unless typeof! @matches-on is 'Object'

    @compiled-list = []
    @debug "compile..."
    # Compiles the matches object of a permit
    for key of @matches-on
      @add-compiled compile-for(key)

    @debug 'compiled matchers:', @compiled-list

  add-compiled: (compiled) ->
    @context.compiled-list.push compiled

  compile-for: (key) ->
    @matches-compiler!.process key, @matches-on[key]

  matches-compiler: ->
    @_matches-compiler ||= new MatchesCompiler @context

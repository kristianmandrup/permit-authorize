Debugger        = require '../../../util' .Debugger
MatchCompiler   = require './match_compiler'

# Takes the context of the form

# matches-on:
#   roles: ['publisher', 'editor']
#   action: 'read'

# then compiles it into an AccessMatcher.match-on(...) statement

module.exports = class MatchesOnCompiler implements Debugger
  (@context, @debugging) ->
    @debug 'context', @context
    @matches-on = @context.matches-on

  compile: ->
    @debug "compile-matchers", @matches-on
    return unless typeof! @matches-on is 'Object'

    @compiled-list = []
    @debug "compile..."
    # Compiles the matches object of a permit
    for key of @matches-on
      @add-compiled @compile-for(key)

    @debug 'compiled matchers:', @compiled-list
    @compiled-list

  add-compiled: (compiled) ->
    @compiled-list.push compiled

  compile-for: (key) ->
    @match-compiler!.compile key, @matches-on[key]

  match-compiler: ->
    @_match-compiler ||= new MatchCompiler @context

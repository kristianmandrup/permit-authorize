Debugger        = require '../../../util' .Debugger
MatchCompiler   = require './match_compiler'

# Takes the context of the form

# matches-on:
#   roles: ['publisher', 'editor']
#   action: 'read'

# then compiles it into an AccessMatcher.match-on(...) statement

module.exports = class MatchesOnCompiler implements Debugger
  (@context, @debugging) ->
    @debug 'compiler', @context, @key
    @compiled = {includes: [], excludes: []}

  compile-all: ->
    compile 'includes'
    compile 'excludes'
    @compiled

  compile: (key) ->
    return false unless @context.compile

    @compile-context = @context.compile[@key]
    @compiled-entry  = @compiled[@key]

    @debug "compile-matchers", @compile-context
    return unless typeof! @compile-context is 'Object'

    @debug "compile..."
    # Compiles the matches object of a permit
    for key of @matches-on
      @add-compiled @compile-for(key)

    @debug 'compiled matchers:', @compiled-list
    @compiled-entry

  # add to includes or excludes
  add-compiled: (compiled) ->
    @compiled-entry.push compiled

  compile-for: (key) ->
    @match-compiler!.compile key, @matches-on[key]

  match-compiler: ->
    @_match-compiler ||= new MatchCompiler @context

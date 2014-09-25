Debugger            = require '../../util' .Debugger
MatchesOnCompiler   = require './compile' .MatchesOnCompiler

/*
compile:
    includes:
        roles: ['publisher', 'editor']
    excludes:
        subject: 'Article'
*/

module.exports = class CompiledMatcher implements Debugger
  (@context, @access-request, @debugging) ->
    @compiled-list = @context.compiled-list or {}
    @compile!
    @

  compile: ->
    @compiled-list ||= @compiler!.compile!

  compiler: ->
    @_compiler ||= new MatchesOnCompiler @context, @debugging

  # TODO: if compiled-list is empty, compile it!
  match: ->
    @debug "match"
    return false unless typeof! @compiled-list is 'Array'
    @debug "compiled matchers: #{@compiled-list.length}"
    @iterate-compiled!

  iterate-compiled: ->
    res = false
    for match-fun in @compiled-list
      break if match-fun @access-request
    res

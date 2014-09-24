Debugger            = require '../../util' .Debugger
MatchesOnCompiler   = require './compile' .MatchesOnCompiler

module.exports = class CompiledMatcher implements Debugger
  (@context, @debugging) ->
    @compiled-list = @context.compiled-list
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
      # console.log match-fun(@access-request)
      break if match-fun @access-request
      # @debug 'compile fun res', res
    res

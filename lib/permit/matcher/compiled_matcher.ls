Debugger = require '../../util' .Debugger

module.exports = class CompiledMatcher implements Debugger
  (@context, @debugging) ->
    @compiled-list = @context.compiled-list

  match-compiled: ->
    @debug "match-compiled"
    return false unless typeof! @compiled-list is 'Array'
    @debug "compiled matchers: #{@compiled-list.length}"

    res = false
    for match-fun in @compiled-list
      # console.log match-fun(@access-request)
      break if match-fun @access-request
      # @debug 'compile fun res', res
    res

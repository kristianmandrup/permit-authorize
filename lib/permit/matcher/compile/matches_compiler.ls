module.exports = class MatchesProcessor
  (@context) ->
    @compiled-list = []

  process: (@key, @value) ->
     @compiler.compile @key, @value

  compiler: ->
    new MatchCompiler @context


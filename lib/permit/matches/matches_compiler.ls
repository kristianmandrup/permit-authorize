module.exports = class MatchesProcessor
  (@permit) ->
    @compiled-list = @permit.compiled-list

  process: (@key, @value) ->
    @add-compiled-match

  add-compiled-match: ->
    @compiled-list.push @compile!

  compile: ->
     @compiler.compile @key, @value

  compiler: ->
    new MatchCompiler @


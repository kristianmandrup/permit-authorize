module.exports = class RepoCleaner
  (@container) ->

  clean-all: ->
    @clean 'can'
    @clean 'cannot'
    @

  # alias
  clear-all: ->
    @clean-all!

  # allow clean only can or cannot rules
  # if no argument, clean both
  clean: (act)->
    return @clean-all! if act is undefined
    unless act is 'can' or act is 'cannot'
      throw Error "Repo can only clear 'can' or 'cannot' rules, was: #{act}"

    @debug 'clean', act
    @repo["#{act}Rules"] = {}
    @

  # alias
  clear: (act)->
    @clean act
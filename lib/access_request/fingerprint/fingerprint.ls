module.exports = class Fingerprint
  (@value) ->
    @

  fingerprint: ->
    @none! or @string!

  string: ->
    @value if typeof! @value is 'String'

  none: ->
    'x' if @value is void
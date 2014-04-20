requires = require '../requires'

_   = require 'prelude-ls'
lo  = require 'lodash'
require 'sugar'

Permit        = requires.lib    'permit'
PermitFilter  = requires.permit 'permit_filter'

Debugger      = requires.lib 'debugger'

module.exports = class Allower implements Debugger
  # access rule
  # example
  # { user: user, action: 'read', subject: book, ctx: {} }

  (@access-request) ->
    # filter to only use permits that make sense for current access request
    @permits = PermitFilter.filter(@access-request)

  # go through all permits that apply
  # if any of them allows, then yes
  allows: ->
    @debug 'allows', @access-request
    @test 'allows'

  # go through all permits that apply
  # if any of them disallows, then yes
  disallows: ->
    @debug 'disallows', @access-request
    @test 'disallows'

  test: (allow-type) ->
    for permit in @permits
      @debug 'test permit', allow-type, permit
      @debug 'with rules', permit.rules
      permit.debug-on! if @debugging

      # apply dynamic rules
      permit.apply-rules @access-request #, true

      @debug 'permit rules'
      return true if permit[allow-type] @access-request
    false

lo.extend Allower, Debugger
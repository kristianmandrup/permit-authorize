util      = require '../../util'

#array     = util.array
#contains  = array.contains
#unique    = array.unique
#object    = util.object

Debugger  = util.Debugger

module.exports = class RepoGuardian implements Debugger
  (@repo, @access-request) ->
    @_validate!

  _validate: ->
    unless typeof! @repo is 'Object'
      throw Error "PermitAllower must take a RuleRepo in constructor, was: #{@repo}"

  test-access: (act) ->
    @debug 'test-access', act, @access-request
    # try to find matching action/subject combination for canRule in repo
    @repo.debug-on! if @debugging
    subj = @repo.match act, @access-request
    @debug 'subj', subj
    subj is true

  # if permit disallows, then it doesn't matter if there is also a rule that allows
  # A cannot rule always wins!
  allows: (ignore-inverse) ->
    @debug 'allows', @access-request, ignore-inverse
    unless ignore-inverse
      return false if @disallows true
    return false if @test-access 'can' is false
    true

  # if no explicit cannot rule matches, we assume the user IS NOT disallowed
  disallows: (ignore-inverse) ->
    @debug 'disallows', @access-request, ignore-inverse
    #unless ignore-inverse
    #  return false if @allows(access-request, true)
    return true if @test-access 'cannot' is true
    false
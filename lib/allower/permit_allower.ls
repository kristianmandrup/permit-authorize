Debugger  = require '../util' .Debugger

module.exports = class PermitAllower implements Debugger
  (@rule-repo, @debugging) ->
    unless typeof! @rule-repo is 'Object'
      throw Error "PermitAllower must take a RuleRepo in constructor, was: #{@rule-repo}"

  test-access: (act, access-request) ->
    @debug 'test-access', act, access-request
    # try to find matching action/subject combination for canRule in rule-repo
    @rule-repo.debug-on! if @debugging
    subj = @rule-repo.match-rule act, access-request
    @debug 'subj', subj
    subj is true

  # if permit disallows, then it doesn't matter if there is also a rule that allows
  # A cannot rule always wins!
  allows: (access-request, ignore-inverse) ->
    @debug 'allows', access-request, ignore-inverse
    unless ignore-inverse
      return false if @disallows(access-request, true)
    return false if @test-access('can', access-request) is false
    true

  # if no explicit cannot rule matches, we assume the user IS NOT disallowed
  disallows: (access-request, ignore-inverse) ->
    @debug 'disallows', access-request, ignore-inverse
    #unless ignore-inverse
    #  return false if @allows(access-request, true)
    return true if @test-access('cannot', access-request) is true
    false

PermitAllower <<< Debugger

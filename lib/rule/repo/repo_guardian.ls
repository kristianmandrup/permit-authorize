module.exports = class RepoGuardian
  (@rule-repo) ->

  permit-allower: ->
    @_permit_allower ||= new PermitAllower @rule-repo, @debugging

  allows: (access-request) ->
    @permit-allower!.allows access-request

  disallows: (access-request) ->
    @permit-allower!.disallows access-request

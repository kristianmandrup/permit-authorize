requires  = require '../requires'
normalize = requires.util 'normalize'
Debugger  = requires.lib 'debugger'

Fingerprints  = requires.access-request 'fingerprints'

module.exports = class AccessRequest implements Debugger, Fingerprints
  # factory method
  @from  = (obj, debugging) ->
    throw new Error "Must be an Object, was: #{obj}" unless typeof! obj is 'Object'
    new AccessRequest(obj.user, obj.action, obj.subject, obj.ctx, debugging)

  # constructor
  (@user, @action, @subject, @ctx, @debugging) ->
    @debug 'create AccessRequest user:', @user, 'action:', @action, 'subject:', @subject, 'ctx:', @ctx
    @validate!
    @normalize!
    @

  # normalize action and subject if they are not each a String
  normalize: ->
    @debug 'normalize action', @action
    @action = normalize @action
    unless typeof! @subject is 'Object'
      @debug 'normalize subject', @subject
      @subject = normalize @subject
    @

  validate: ->
    unless @valid-action!
      throw new Error "Missing action name. Must authorize an action to be performed on a subject, was: #{@action}, #{typeof! @action}"

    unless @valid-subject!
      throw new Error "Missing subject. Must authorize a subject to perform an action: #{@action}"

    unless @valid-user!
      throw new Error "Missing or invalid user. Must authorize a user to perform an action: #{@action} on the subject, was: #{@user} of type: #{typeof! @user}"

  valid-subject: ->
    @subject?

  valid-user: ->
    typeof! @user is 'Object'

  valid-action: ->
    typeof! @action is 'String' or typeof! @action is 'Array'
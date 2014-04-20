requires  = require '../requires'
normalize = requires.util 'normalize'
Debugger  = requires.lib 'debugger'

module.exports = class AccessRequest implements Debugger
  # factory method
  @from  = (obj) ->
    new AccessRequest(obj.user, obj.action, obj.subject, obj.ctx)

  # constructor
  (@user, @action, @subject, @ctx, debug) ->
    @debug-on! if debug
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

  validate: ->
    unless typeof! @action is 'String'
      throw new Error "Missing action name. Must authorize an action to be performed on a subject, was: #{@action}, #{typeof! @action}"

    unless @subject?
      throw new Error "Missing subject. Must authorize a subject to perform an action: #{@action}"

    unless typeof! @user is 'Object'
      throw new Error "Missing user. Must authorize a user to perform an action: #{@action} on the subject"

normalize     = require '../util' .normalize
Debugger      = require '../util' .Debugger
FingerPrinter = require './fingerprint' .FingerPrinter

module.exports = class AccessRequest implements Debugger
  # factory method
  @from  = (obj, debugging) ->
    throw new Error "Must be an Object, was: #{obj}" unless typeof! obj is 'Object'
    new AccessRequest(obj.user, obj.action, obj.subject, obj.ctx, debugging)

  # constructor
  (@user, @action, @subject, @ctx, @debugging) ->
    @ar-obj = {user: @user, action: @action, subject: @subject, ctx: @ctx}
    @debug 'create AccessRequest user:', @user, 'action:', @action, 'subject:', @subject, 'ctx:', @ctx
    @validate!
    @normalize!
    @

  fingerprint: ->
    _fingerprinter ||= new FingerPrinter @ar-obj
    _fingerprinter.access-hash!

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
      console.log "ar", @ar-obj
      throw new Error "Missing action name. Must authorize an action to be performed on a subject, was: #{@action}, #{typeof! @action}"

    unless @valid-subject!
      console.log "ar", @ar-obj
      throw new Error "Missing subject. Must authorize a subject: #{@subject} to perform an action: #{@action}"

    unless @valid-user!
      console.log "ar", @ar-obj
      throw new Error "Missing or invalid user. Must authorize a user: #{@user} to perform an action: #{@action}"

  valid-subject: ->
    @subject?

  valid-user: ->
    typeof! @user is 'Object'

  valid-action: ->
    typeof! @action is 'String' or typeof! @action is 'Array'

AccessRequest <<< Debugger
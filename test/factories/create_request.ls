requires  = require '../../requires'
User      = requires.fix 'user'

module.exports =
  empty: ->
    {}

  default-action: ->
    'read'

  default-user: ->
    new User name: 'kris'

  role-access: (role) ->
    user:
      role: role
    action: @default-action!

  user-access: (user) ->
    user: user
    action: @default-action!

  action-access: (action) ->
    user: @default-user!
    action: action

  subject-access: (subject) ->
    user: @default-user!
    subject: subject
    action: @default-action!

  ctx-access: (ctx) ->
    user: @default-user!
    action: @default-action!
    ctx: ctx

  context-access: (ctx) ->
    @ctx-access ctx

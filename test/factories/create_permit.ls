requires  = require '../../requires'

Permit        = requires.lib 'permit'
permit-for    = requires.permit 'factory' .permit-for

permit-class  = requires.fix  'permit-class'

GuestPermit = permit-class.GuestPermit

module.exports =
  guest: (debug) ->
    permit-for GuestPermit, 'guest books', (->
      rules:
        ctx:
          area: 
            visitor: ->
              @ucan 'publish', 'Paper'
        read: ->
          @ucan 'read' 'Book'
        write: ->
          @ucan 'write' 'Book'
        default: ->
          @ucan 'read' 'any'
      ), debug

  admin: (debug) ->
    permit-for Permit, 'admin books', (->
      rules:
        user:
          kris: ->
            @ucan 'manage', 'User'
        ctx:
          area:
            admin: ->
              @ucan 'review', 'Paper'
        subject:
          paper: ->
            @ucan 'approve', 'Paper'
    ), debug

  matching:
    user: ->
      permit-for 'User',
        match: (access) ->
          @debug access
          @matching(access).user!
        rules: ->
          @ucan ['read', 'edit'], 'book'

    ctx:
      auth: ->
        permit-for 'auth',
          match: (access) ->
            @matching(access).has-ctx auth: 'yes'

          rules: ->
            @ucan 'manage', 'book'

    role:
      guest: ->
        permit-for 'Guest',
          match: (access) ->
            @debug access
            @matching(access).role 'guest'

          rules: ->
            @ucan 'read', 'book'

      admin: ->
        permit-for 'admin',
          match: (access) ->
            @debug access
            @matching(access).role 'admin'

          rules: ->
            @ucan 'write', 'book'
            @ucan 'edit', 'user'
            # @ucan 'manage', '*'

module.exports =
  basic:
    edit: ->
      @ucan     'edit',   'Book'
      @ucannot  'write',  'Book'
    read: ->
      @ucan    'read',   ['Book', 'Paper', 'Project']
      @ucannot 'delete', ['Paper', 'Project']

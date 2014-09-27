module.exports = (@subject) ->
  # always return string, to ensure string comparison valid when matching,
  # including (later) regex tests if necessary
  clazz: ->
    camel-case (@find-class || '')

  find-class: ->
    res = switch typeof! @subject
    when 'Object'
      @object-class!
    when 'String'
      @subject!
    default
      void

  instance: ->
    @_instance ||= @get-instance! || {}

  get-instance: ->
    if @one-key! then @outer-value! else @subject

  # protected

  outer-value: ->
    @subject[@first-key!]

  one-key: ->
    Object.keys @subject .length == 1

  object-class: ->
    if @one-key! then @outer-class! else @inner-class!

  first-key: ->
    Object.keys @subject .0

  outer-class: ->
    @first-key!

  inner-class: ->
    return subject.constructor.display-name if subject.constructor.display-name
    subject.clazz or subject._clazz or subject.$clazz or subject._class or subject.$class

obj-class = (subject) ->
  return subject.constructor.display-name if subject.constructor.display-name
  subject.clazz or subject._clazz or subject.$clazz or subject._class or subject.$class

camel-case = (s) ->
  (s or '').to-lower-case!.replace /(\b|-)\w/g, (m) ->
    m.to-upper-case!.replace /-/, ''

module.exports =
  camel-case: camel-case
  camelize: camel-case

  clazz-for: (subject) ->
    res = switch typeof! subject
    when 'Object'
      obj-class subject
    when 'String'
      subject
    default
      void
    camel-case res || ''

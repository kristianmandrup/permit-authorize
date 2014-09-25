Debugger      = require '../../util' .Debugger
BaseMatcher   = require './base_matcher'
camelize      =  require '../../util' .string.camel-case

module.exports = class SubjectMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-subject!
    @set-subject-class!
    @

  set-subject-class: ->
    @subject-class = @clazz-for @subject

  set-subject: ->
    @subject ||= if @access-request? then @access-request.subject else {}

  match: (subject) ->
    @debug 'match subjects', @subject, subject
    if typeof! subject is 'Function'
      return subject.call @subject
    return true if @death-match 'subject', subject
    @intersect.on subject, @subject

  match-clazz: (subject) ->
    @debug 'match-clazz', subject, @subject-class
    @clazz-for(subject) is @subject-class

  clazz-for: (subject) ->
    res = switch typeof! subject
    when 'Object'
      @obj-class subject
    when 'String'
      subject
    default
      void
    camelize res || ''

  obj-class: (subject) ->
    return subject.constructor.display-name if subject.constructor.display-name
    subject.clazz or subject._clazz or subject.$clazz or subject._class or subject.$class


SubjectMatcher <<< Debugger

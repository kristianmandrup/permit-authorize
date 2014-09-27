Debugger      = require '../../util' .Debugger
BaseMatcher   = require './base_matcher'
util          = require '../../util'
camelize      = util.string.camel-case
subject-for   = util.subject

module.exports = class SubjectMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-subject!
    @set-subject-class!
    @

  set-subject-class: ->
    @subject-class = @subject-for(@subject).clazz!

  set-subject: ->
    @subject ||= @subject-instance!

  subject-instance: ->
    subject-for(@access-request.subject).instance!

  match: (subject) ->
    @debug 'match subjects', @subject, subject
    if typeof! subject is 'Function'
      return subject.call @subject
    return true if @death-match 'subject', subject
    @intersect.on subject, @subject

  match-clazz: (subject) ->
    @debug 'match-clazz', subject, @subject-class
    subject-for(subject).clazz! is @subject-class

SubjectMatcher <<< Debugger

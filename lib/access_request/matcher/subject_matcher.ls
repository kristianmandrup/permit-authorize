Debugger      = require '../../util' .Debugger
BaseMatcher   = require './base_matcher'
util          = require '../../util'
camelize      = util.string.camel-case
clazz-for     = util.string.clazz-for

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
    clazz-for(subject) is @subject-class

SubjectMatcher <<< Debugger

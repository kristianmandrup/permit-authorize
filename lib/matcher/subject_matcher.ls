requires        = require '../../requires'
lo              = requires.util 'lodash-lite'

Debugger        = requires.lib 'debugger'
BaseMatcher     = requires.matcher 'base'

class SubjectMatcher extends BaseMatcher
  (@access-request) ->
    super ...
    @set-subject!

  set-subject: ->
    @subject ||= if @access-request? then @access-request.subject else {}

  match: (subject) ->
    if typeof! subject is 'Function'
      return subject.call @subject
    return true if @death-match 'subject', subject
    @intersect.on subject, @subject

  match-clazz: (subject) ->
    clazz = subject.camelize!
    return false unless @subject and @subject.constructor
    @subject.constructor.display-name is clazz

lo.extend SubjectMatcher, Debugger

module.exports = SubjectMatcher
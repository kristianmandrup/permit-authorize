util      = require '../../../util'
Debugger  = util.Debugger

clazz-for   = util.string.clazz-for
camelize    = util.string.camel-case

module.exports = class RuleSubjectMatcher implements Debugger
  (@subjects) ->
    unless typeof! @subjects is 'Array'
      throw new Error "subject must be an Array, was: #{@subjects}"

  match: (subject) ->
    @debug 'match', subject

    # first try wild-card 'any' or '*'
    return true if contains @wildcards, subject

    if typeof! subject is 'Array'
      return contains @subjects, subject

    unless typeof! subject is 'String'
      throw Error "find-matching-subject: Subject must be a String to be matched, was #{subject}"

    camelized = camelize subject
    subjects.index-of(camelized) != -1

  wildcards: ['*', 'any']
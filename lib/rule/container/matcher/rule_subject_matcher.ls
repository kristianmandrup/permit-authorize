util      = require '../../../util'
Debugger  = util.Debugger

subject-for = util.subject
camelize    = util.string.camel-case
union       = util.array.union
normalize   = util.normalize
wildcards   = util.globals.wildcards

RuleMixin   = require '../rule_mixin'

module.exports = class RuleSubjectMatcher implements Debugger
  (@subjects, @debugging) ->
    @debug 'subjects', @subjects
    @subjects = @_class-normalize @subjects
    @_validate!
    @

  match: (ar-subjects) ->
    ar-subjects = @_class-normalize ar-subjects
    @debug 'match', @subjects, 'with', ar-subjects
    @intersects(@wild-cards) or @intersects ar-subjects

  intersects: (ar-subjects) ->
    intersect(@subjects, ar-subjects).length > 0

  wild-cards: wildcards

  _validate: ->
    unless typeof! @subjects is 'Array'
      throw new Error "subject must be an Array, was: #{@subjects}"

  _class-normalize: (ar-subjects) ->
    normalize(ar-subjects).map (ar-subject) ->
      return subject-for(ar-subject).clazz!

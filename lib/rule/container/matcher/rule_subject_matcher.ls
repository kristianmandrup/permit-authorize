util      = require '../../../util'
Debugger  = util.Debugger

clazz-for   = util.string.clazz-for
camelize    = util.string.camel-case
union       = util.array.union
normalize   = util.normalize

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

  wild-cards: ['Any', '*']

  _validate: ->
    unless typeof! @subjects is 'Array'
      throw new Error "subject must be an Array, was: #{@subjects}"

  _class-normalize: (subjects) ->
    normalize(subjects).map (subject) ->
      return camelize subject

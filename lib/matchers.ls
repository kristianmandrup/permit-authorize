requires = require '../requires'

BaseMatcher     = requires.matcher 'base'
UserMatcher     = requires.matcher 'user'
ActionMatcher   = requires.matcher 'action'
SubjectMatcher  = requires.matcher 'subject'
ContextMatcher  = requires.matcher 'context'
AccessMatcher   = requires.matcher 'access'

module.exports =
  BaseMatcher     : BaseMatcher
  UserMatcher     : UserMatcher
  ActionMatcher   : ActionMatcher
  SubjectMatcher  : SubjectMatcher
  ContextMatcher  : ContextMatcher
  AccessMatcher   : AccessMatcher
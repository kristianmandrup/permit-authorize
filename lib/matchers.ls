BaseMatcher     = require './matcher/base_matcher'
UserMatcher     = require './matcher/user_matcher'
ActionMatcher   = require './matcher/action_matcher'
SubjectMatcher  = require './matcher/subject_matcher'
ContextMatcher  = require './matcher/context_matcher'
AccessMatcher   = require './matcher/access_matcher'

module.exports =
  BaseMatcher     : BaseMatcher
  UserMatcher     : UserMatcher
  ActionMatcher   : ActionMatcher
  SubjectMatcher  : SubjectMatcher
  ContextMatcher  : ContextMatcher
  AccessMatcher   : AccessMatcher
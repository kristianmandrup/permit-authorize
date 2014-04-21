requires  = require '../../../requires'
requires.test 'test_setup'

string-util = requires.util 'string_util'
camel-case  = string-util.camel-case

describe 'string_util' ->
  describe 'camel-case' ->
    specify 'camelized full upper case' ->
      camel-case 'user-admin' .should.eql 'UserAdmin'


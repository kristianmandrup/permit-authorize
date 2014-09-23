requires  = require '../../../requires'
requires.test 'test_setup'

string = requires.util 'string'

describe 'string_util' ->
  describe 'camelCase' ->
    specify 'camelized full upper case' ->
      string.camel-case 'user-admin' .should.eql 'UserAdmin'


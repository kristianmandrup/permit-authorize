requires  = require '../../requires'

requires.test 'test_setup'

User      = requires.fix 'user'
intersect = requires.util('intersect')!

describe 'Intersect' ->
  var kris-user, guest-user, admin-user, kris-admin-user

  before ->
    kris-user         := new User name: 'kris'
    guest-user        := new User role: 'guest'
    admin-user        := new User role: 'admin'
    kris-admin-user   := new User name: 'kris', role: 'admin'

  describe 'on' ->
    # test if first object (partial) intersects fully on target object
    specify 'does NOT intersects on object with no overlap' ->
      intersect.on({user: 'x'}, {user: 'y'}).should.be.false

    specify 'does NOT intersects on users with no overlap' ->
      intersect.on({user: kris-user}, {user: guest-user}).should.be.false

    specify 'intersects on same object' ->
      intersect.on({user: kris-user}, {user: kris-user}).should.be.true

    specify 'does NOT intersects when partial is > obj' ->
      intersect.on({user: kris-admin-user}, {user: admin-user}).should.be.false

    specify 'intersects on object with partial overlap on target obj' ->
      intersect.on({user: admin-user}, {user: kris-admin-user}).should.be.true

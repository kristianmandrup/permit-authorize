# Permit Authorizer

Authorization via Permits for Javascript.

This library has been developed for *Node.js* but can be used on any platform which supports either
the [CommonJS[(http://wiki.commonjs.org/wiki/CommonJS) or [RequireJS](http://requirejs.org/docs/node.html) module system.

 ## Design and Architecture

See [wiki](https://github.com/kristianmandrup/permit-authorize/wiki) for an overview.

Most important sections:

* [Permits](https://github.com/kristianmandrup/permit-authorize/wiki/Permits)
* [Rules](https://github.com/kristianmandrup/permit-authorize/wiki/Rules)

This project was extracted from [authorize-mw](https://github.com/kristianmandrup/authorize-mw) to provide a self contained authorization
solution. The authorize-mw project is part of a general purpose middleware stack.

## Code

The code has been developed in [LiveScript](http://livescript.net/) which is very similar too [Coffee script](http://coffeescript.org/).
See [coffee-to-ls](http://livescript.net/#coffee-to-ls)

## Installation

The main file is `index.js` which exposes the following:

```
Authorizer :   requires.lib 'authorizer'
Ability :      requires.lib 'ability'
Allower :      requires.lib 'allower'
Permit :       requires.lib 'permit'
permit-for:    requires.permit 'permit-for'
```

To use this library...

```javascript
authorize = require('permit-authorize');
```

Then require what you need as demonstrated in the usage examples below.

```javascript
Permit      = authorize.Permit;
permit-for  = authorize.permit-for;
```

`permit-for` is a factory method to create permits. The other keys all point to constructor functions in the form of LiveScript "classes".

## Browser usage

Try [browserify](http://browserify.org)

`browserify index.js -o permit-authorize.js`

## Usage examples

The following is a complete example, using LiveScript syntax for a clearer picture.

```LiveScript
lo = require 'lodash'

authorize = require 'permit-authorize'

Permit      = authorize.Permit
permit-for  = authorize.permit-for

class Book extends Base
  (obj) ->
    super ...

book = new Book title: title

class GuestUser extends User
  (obj) ->
    super ...

  role: 'guest'

guest-user   = new GuestUser name: 'unknown'

guest-permit = permit-for('guest',
  match: (access) ->
    @matches(access).user role: 'guest'

  rules:
    ctx:
      area:
        guest: ->
          @ucan 'publish', 'Paper'
        admin: ->
          @ucannot 'publish', 'Paper'

    read: ->
      @ucan 'read' 'Book'
    write: ->
      @ucan 'write' 'Book'
    default: ->
      @ucan 'read' 'any'
)

Ability     = authorize.Ability

user = (name) ->
  new User name

book = (title) ->
  new Book title

ability = (user) ->
  new Ability user

a-book = book 'some book'
current-user = user 'kris'

current-ability = ability(current-user)

user-can = (access-request) ->
  current-ability.can access-request

if user-can action: 'read', subject: a-book
  # code to read the book
```

The same example in Javascript (see *usage-examples* folder):

First we include the main authorize modules to be used

```javascript

var lo, authorize, Permit, permitFor, Ability,
    Book, book,
    GuestUser, guestUser,
    GuestPermit, guestPermit,
    user, ability, aBook, currentUser, currentAbility,
    userCan, readBook;

lo = require('lodash');

authorize = require('permit-authorize');

Ability = authorize.Ability;
Permit = authorize.Permit;
permitFor = authorize.permitFor;
```

Then we set up some user models:

```
User = require(./models/user');

GuestUser = function(properties){
  // User prototypical inheritance?
  // guest user constructor code...
}
// all guest users have a role of guest
GuestUser.prototype.role = 'guest';

guestUser = new GuestUser({
  name: 'a guest'
});
```

We define a permit to use for authorization

```
GuestPermit = new Permit('guest');

// The GuestPermit only applies if the access request contains a user with role = 'guest'
GuestPermit.prototype.

guestPermit = permitFor('guest', {
  // Determine when the permit applies
  match: function(access){
      return this.matches(access).user({
        role: 'guest'
  },
  // authorization rules to apply when permit applies
  rules: {
    // context dependent rules (dynamic)
    ctx: {
      area: {
        guest: function(){
          return this.ucan('publish', 'Paper');
        },
        admin: function(){
          return this.ucannot('publish', 'Paper');
        }
      }
    },
    // action rules (dynamic)
    read: function(){
      return this.ucan('read', 'Book');
    },
    write: function(){
      return this.ucan('write', 'Book');
    },
    // default rule always applies for any user, action, subject or context
    // static rules
    'default': function(){
      return this.ucan('read', 'any');
    }
  }
});

// utility functions and constructors...
user = function(name){
  return new User(name);
};

Book = function(properties){
  // book constructor code...
}

book = function(title){
  return new Book(title);
};

ability = function(user){
  return new Ability(user);
};

userCan = function(accessRequest){
  return currentAbility.can(accessRequest);
};

userCannot = function(accessRequest){
  return currentAbility.cannot(accessRequest);
};


readBook = function(user, book){
  // code for user to read the book
};


aBook           = book('some book');
currentUser     = user('kris');
currentAbility  = ability(currentUser);

// Finally, here we go :)

if (userCan({action: 'read', subject: aBook})) {
  readBook(currentUser, aBook);
}

if (userCannot({action: 'read', subject: 'Book'})) {
  throw new Error("Stupid illiterate user!");
}
```

## Current status

All tests are passing :)

Note to self: *rule-applier* needs more tests...

To facilitate testing, each class implements `Debugger` which allows using `debug-on!` on the class or instance level to track
 what goes on inside.

Use `xdescribe`, `describe.skip` and `describe.only` to select which tests to execute.

### Caching

A caching strategy has been implemented, so rules are not evaluated
each time for the same `AccessRequest` (user, action, subject, context) .
Instead a cached authorization result for that `AccessRequest` will be retrieved from the cache and returned.

For each of the elements making up the `AccessRequest` to get the "fingerprint":
- Object: `hash` function is attempted called defaulting to JSON stringify if not present.
- String: value is fingerprint
- Array: values combined with '.'

Each of these fingerprints is concatenated into one *access request fingerprint*.
If an `AccessRequest` with the same fingerprint (hash) is evaluated again, the cached authorization result is fetched
for much better performance!

Please note that the current implementation could use some refactoring to remove code duplication of the can- and cannot-cache
since they are essentially the same.

## Design

*Why LiveScript?*

Since it is faster/easier to develop the basic functionality. Should be easy later refactor the code to use another approach.

*Why classes and not prototypical inheritance?*

See reasoning for Livescript. Was simply easier/faster to implement using classes.

Feel free to fork this project and provide a version without classes if that is a MUST for you...

## Testing

Run `mocha` on all files in test folder

Just run all test like this:

`$ mocha`

To execute individual test, do like this:

`$ mocha test/authorize-mw/permit_test.js`

### Test coverage

The library [istanbul](http://ariya.ofilabs.com/2012/12/javascript-code-coverage-with-istanbul.html) is used for code coverage.

See [code-coverage-with-mocha](http://stackoverflow.com/questions/16633246/code-coverage-with-mocha) for use with mocha.

```
npm install -g istanbul
istanbul cover _mocha -- -R spec
open coverage/lcov-report/index.html
```

`$ istanbul cover _mocha`

 To measure coverage of individual test:

 `$ istanbul cover _mocha test/authorize-mw/permit_test.js`

## Contribution

Please help improve this project, suggest improvements, add better tests etc. ;)

## Licence

MIT License
Copyright 2014-2015 Kristian Mandrup

See LICENSE file
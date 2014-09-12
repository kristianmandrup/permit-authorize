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

## Concepts

The basic idea is as follows:

A *subject* (fx a user) can perform an *action* on a given *object* if the subject has a *permit* for that action.

## Main features

- Simple DSL based permit configuration (via `permit-for`)
- Ability Caching for enhanced performance (2ms lookup!)
- Turn debugging on/off on classes or instances
- Load permit rules from JSON (f.ex from file or data store) 
- Huge test suite included
- Only 53kb minified :) 

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

## Non CommonJS (Node) usage

To use this library outside a CommonJS environment (using `require` for module loading), you can generate
 a single file that contains all the library code concatenated. 

Try [browserify](http://browserify.org)

`browserify index.js -o permit-authorize.js`

To uglify and minimize...

`uglifyjs permit-authorize.js -cm > permit-authorize.min.js`

Standalone files available: 

- `permit-authorize.js` 
- `permit-authorize.ugly.js`
- `permit-authorize.min.js`

 Using `bower install` will install `permit-authorize.min.js` in the 
bower components folder of your app (default: `bower_components`).

## Usage examples

The following is a complete example, using LiveScript syntax for a clearer picture.

First we require the basic modules

```LiveScript
authorize   = require 'permit-authorize'
Permit      = authorize.Permit
permit-for  = authorize.permit-for
```

Then we define a `Book` model to be used as a "protected resource" (object).

```LiveScript
class Book extends Base
  (obj) ->
    super ...

book = (title) ->
  new Book title

a-book = book 'some book'
```

Load Ability class and define convenience helper method

```LiveScript
Ability     = authorize.Ability

ability = (user) ->
  new Ability user
```


Then we create a `GuestUser` class and a `guest-user` (subject)

```LiveScript
class GuestUser extends User
  (obj) ->
    super ...

  role: 'guest'

user = (name) ->
  new User name

guest-user = (name) ->
  new GuestUser name
```

Define some useful variables

```LiveScript
a-guest-user = guest-user 'unknown'

current-user = a-guest-user

current-ability = ability(current-user)
```

Now we need to define a permit that matches for a guest user (role) and 
defines what actions the subject (guest user) can perform on a Book (object).  

```LiveScript
guest-permit = permit-for('guest',
  matches-on: 
    role: 'guest'

  rules:
    read: ->
      @ucan 'read' 'Book'
    write: ->
      @ucan 'write' 'Book'
    default: ->
      @ucan 'read' 'any'
)
```

Define helper method `user-can`

```
user-can = (access-request) ->
  current-ability.can access-request
```

And use it like this

```
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
guestPermit = permitFor('guest', {
  // Determine when the permit applies
  matches-on: {
    role: 'guest'
  },
  // authorization rules to apply when permit applies
  rules: {
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

// here we go :)

if (userCan({action: 'read', subject: aBook})) {
  readBook(currentUser, aBook);
}

// or using implicit hash in the implied order: action, subject, context

if (userCannot('read', 'Book')) {
  throw new Error("Stupid illiterate user!");
}
```

## Current status

All tests are passing :)

To facilitate testing, each class implements `Debugger` which allows using `debug-on!` on the class or instance level to track
 what goes on inside.

Use `xdescribe`, `describe.skip` and `describe.only` to select which tests to execute.

### Caching

A caching strategy has been implemented as `CachedAbility`.

When using a `CachedAbility`, a cached authorization result for an `AccessRequest` will be retrieved
from the cache and returned if present. If not found, a result will be generated and cached.
The caching solution uses a fingerprint of the `AccessRequest` to determine the cache key.

*Fingerprinting*

For each of the elements making up the `AccessRequest` to get the "fingerprint":
- Object: `hash` function is attempted called defaulting to JSON stringify if not present.
- String: value is fingerprint
- Array: values combined with '.'

Each of these fingerprints are concatenated into one fingerprint to be used as the cache key.
If an `AccessRequest` with the same fingerprint (hash) is evaluated again later, the cached authorization result is fetched
immediately for much better performance!

Please not that it is highly recommended to add a `hash` method to your `User` and subject models in order for the fingerprinting to work
correctly and efficiently.

### Performance using CachedAbility

The result can be seen by running *cached_ability_test.js*

```LiveScript
for i from 1 to 10
  ability.guest.not-allowed-for(action: 'write', subject: book).should.be.true
```

`guest ability: uncached: 123ms` vs `guest ability: cached: 2ms`

Pretty cool :)

## Loading rules from JSON file

```LiveScript
# my/rules/editor_rules.json
{
    "editor": {
        "can": {
            "edit": "book",
            "publish": "paper"
        }
    }
}
```


```LiveScript
authorize = require 'permit-authorize'
RulesLoader  = authorize.RulesLoader
 
editor-permit.rules = new RulesLoader.load('my/rules/editor_rules.json')
```

Some extras to facilitate creating permits from rule files or data stores

```LiveScript
rules-loader  = new RulesLoader('my/rules/editor_rules.json')
permit        = rules-loader.create-permit 'editor permit'

# or subclass permit from existing AdminPermit class
rules-loader  = new RulesLoader('my/rules/admin_rules.json')
permit        = rules-loader.create-permit 'admin permit', AdminPermit
```

## Load rules from a Data store/base

You can easily extend the `lib/permit/permit_rules_loader.ls` to load authorization rules from a Database.
See the `lib/permit/permit_rules_db_loader.ls` for a skeleton you can extend to suit your needs.

```LiveScript
  load-db: (@options = {}) ->
    @connect-db!
    @load-data!
    @loaded-rules = JSON.parse data
    @process-rules!

  # connect to DB
  connect-db: ->

  # load the rules from DB into a JSON structure
  load-data: ->
```

Simply override the `connect-db` and `load-data` functions as needed. 
Then use it something like this.

```LiveScript
DbRulesLoader  = authorize.DbRulesLoader
rules = DbRulesLoader.load-db('http://my/connect/url:12345', {user: 'myname', password: 'secret'})
```

## Design

*Why LiveScript?*

Since it is faster/easier to develop the basic functionality. Should be easy later refactor the code to use another approach.

*Why classes and not prototypical inheritance?*

See reasoning for Livescript. Was simply easier/faster to implement using classes.

Feel free to fork this project and provide a version without classes if that is a MUST for you...

## TODO

- *rule-applier* needs more tests...
- refactor *rule-applier* and some other core modules that have functions of more than 3 lines!
- optimize for speed! I think the engine could be at least twice as fast with some optimizations... (mostly: caching and lazy loads)

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
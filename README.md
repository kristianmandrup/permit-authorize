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
- Ability Caching for enhanced performance (2ms consecutive lookup!)
- Turn debugging on/off on classes or instances
- Load permit rules from JSON (f.ex from file or data store) 
- Huge test suite included
- Less than ~50 kb minified :) 

## Code

The code has been developed in [LiveScript](http://livescript.net/) which is very similar too [Coffee script](http://coffeescript.org/).

See [coffee-to-ls](http://livescript.net/#coffee-to-ls)

## Installation

### Bower

Standalone files available in `/dist` folder: 

- `permit-authorize.js` 
- `permit-authorize.min.js`
- `es6/permit-authorize.js`

Using `bower install` will install all these files in the *bower components* folder of your app (default: `bower_components`).

`bower info permit-authorize`
`bower install permit-authorize --save`

The main file is `index.js` which exposes the following keys:

```coffeescript
  ability
  accessRequest
  allower
  authorizer
  permit
  rule
  util
```

This should allow you great flexibility to override/customize any functionality you need by "monkey patching", ie. change whatever functions or classes to your liking (if need be).

## Usage examples

### index.html

Loads global variable `permitAuthorize` object with all the exposed keys outlined above (see `index.js`)

```html
<script src="/bower_components/permit-authorize/dist/permit-authorize.js"></script>
```

### Node.js

Simply use `require`

```javascript
var pa   = require('permit-authorize');

// define local "shorthand" vars
var Ability       = pa.ability.Ability;
var RulesLoader   = pa.permit.rule.loader.RulesFileLoader;
var permitFor     = pa.permit.factory.permitFor;
```

### ES6 modules 

For an Ember CLI app:

AMD module imported into app as `'permit-authorize'`.

```Brocile
app.import('/bower_components/permit-authorize/dist/permit-authorize.js', {
  'permit-authorize': [
    'ability',
    'permit',
    'rule'
  ]
})
```

Alternatively directly import `permit-authorize` as an ES6 module from the `/dist/es6` folder.

```Brocile
app.import('/bower_components/permit-authorize/dist/es6/permit-authorize.js')
```

Now import the modules you need in each of your local app module ;)

```javascript
import { ability, permit } from 'permit-authorize';
```

`Ability` is a useful wrapper for a `User` object, such as `currentUser` which is sent along with the `AccessRequest`object to the `Allower` to be resolved. `permitFor` is a factory method to create permits that hold permission rules. 
`RulesLoader` can be used to load rules into a permit from a JSON source, such as a JSON file.

## Full usage example (LiveScript)

Note: LiveScript is very similar to coffeescript. One extra feature is that it turns dashed names into camelCase

`permit-for` => (resolved to) `permitFor`

First we define a `Book` model to be used as a "protected resource" (object).

```LiveScript
class Book extends Base
  (obj) ->
    super ...

# helper facotory method
book = (title) ->
  new Book title

# create sciFiBook
sci-fi-book = book 'A journey to Mars'
```

Load Ability class and define convenience helper method

```LiveScript
Ability     = authorize.Ability

# factory method
ability = (user) ->
  new Ability user
```


Then we create a `GuestUser` class and a `guest-user` (subject). 
We assume here that we already have a `User` class.

```LiveScript
class GuestUser extends User
  (obj) ->
    super ...

  role: 'guest'

# user factory method
user = (name) ->
  new User name

# guestUser factory method
guest-user = (name) ->
  new GuestUser name
```

Define some users

```LiveScript
a-guest-user = guest-user 'unknown'

current-user = a-guest-user
```

wrap the current user in an ability

```LiveScript
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

```LiveScript
user-can = (access-request) ->
  current-ability.can access-request
```

And use it like this

```LiveScript
if user-can action: 'read', subject: a-book
  # code to read the book
```

### Permit Container

All permits are registered in the same PermitRegistry singleton. When filtering, which permits should be taken into account,
 the default implementation is to iterate through the whole registry.
However for many use cases, it makes sense to group permits in categories, f.ex by environment (dev, test, prod) or by domain 
(guest, user, admin) etc. To enable this, you can add a permit to a specific PermitContainer, then set one container as active.
 
Example:
 
```LiveScript
permit-container = (name, desc)
    new PermitContainer(name, desc)

containers = 
    dev: permit-container 'dev', 'permits for development only'
    prod: permit-container 'prod', 'permits for production' 

containers.prod.activate!

admin-permit = permit-for 'admin user', ->
    ...
    
# add this permit to dev container (will be ignored, since this container is not active)
containers.dev.add admin-permit

# add this permit to prod container (will be used, since this container is active)
containers.prod.add prod-admin-permit

# you can active/deactivate containers as you like
containers.prod.deactivate!
containers.dev.activate!
containers.test.activate!
containers.admin.activate!
```

### Debugging

To facilitate testing, each class implements `Debugger` which allows using `debug-on!` on the class or instance level to track
 what goes on inside.

### Testing

Use `xdescribe`, `describe.skip` and `describe.only` to select which tests to execute.

### Caching

A caching strategy for Ability has been implemented as `CachedAbility`.

When using a `CachedAbility`, a cached authorization result for an `AccessRequest` will be retrieved
from the cache and returned if present. If not found, a result will be generated and cached.
The caching solution uses a *fingerprint* of the `AccessRequest` to determine the cache key.
The fingerprinting can be customized...

*Fingerprinting*

The incoming `AccessRequest` is an object with keys and values.
For each of the values making up the `AccessRequest`, to create the *fingerprint*:
- Object: `hash` function is attempted called defaulting to JSON stringify if not present.
- String: value is fingerprint
- Array: fingeprints of all items concatenated with '.'

Each of these fingerprints are concatenated into one fingerprint to be used as the full cache key.
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

## Design

*Why LiveScript?*

Since it is faster/easier to develop the basic functionality. Should be easy later refactor the code to use another approach.

*Why classes and not prototypical inheritance?*

See reasoning for Livescript. Was simply easier/faster to implement using classes.

## Roadmap towards 1.0

- RuleApplier* needs more tests...
- refactor *RuleApplier* and some other core modules for more granularity and better testing
- optimize for speed!

## Contribution

Please help improve this project, suggest improvements, add better tests etc. ;)

### Utility functions + dependencies

Currently dependencies to a few lodash functions

[lodash custom builds](http://lodash.com/custom-builds)

```bash
$ npm install -g lodash-cli
$ lodash include=extend,filter,find,map,unique
```

### Browserify

[browserify](http://browserify.org)

Exposes a single global variable `permitAuthorize`

`browserify index.js --s permitAuthorize > permit-authorize.js`

To uglify (minimize)

`uglifyjs permit-authorize.js -cm > permit-authorize.min.js`

For convenience, simply run the `browserify-all.sh` shell script in the project root.

## ES6 compatible modules

Experimental `e6ify.js` now included:

- http://thlorenz.github.io/es6ify/
- https://github.com/thlorenz/es6ify/blob/master/example/build.js

## Licence

MIT License
Copyright 2014-2015 Kristian Mandrup

See LICENSE file
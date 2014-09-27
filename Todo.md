## TODO

### Subject (impl. done - needs test) 

clazz-for, instance-for

If subject has only one key and no `class` key, then assume that key is the class and value is the subject.

instance-for should clone <<< and normalize the class to this format:

```
{
    title: 'My first post'
    $clazz: 'Post' 
}
```

### Cache and Permit Observers

Every cache should observe Permit.registry and PermitContainer.

```
Permit.registry should be available on load not on first permit!

cache.observe(Permit.registry, PermitContainer)
 
cache.observe = (...targets) ->
    for target in targets 
        target.addObserver @

Permit.registry.addObserver = (observer) ->
    observers.push observer

Permit.registry.notify = (event) ->
    for observer in observers
        observer.notify event, @
```    

### Rule match

matches:

#  intersect:
#    includes:
#      user:
#        role: 'admin'
#    excludes:
#      user:
#        name: 'My evil twin'

    compile:
        includes:
            roles: ['editor', 'publisher']

    includes:
        user-admin: # intersect since not a function
            user:
                admin: true
    excludes:
        evil-user: # intersect since an object
            user:
                name: 'My evil twin'
        bad-cousin: -> # function
            @matching!.match-on subject-clazz: 'cousin', type: 'bad'
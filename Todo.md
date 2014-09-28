## TODO

### Tests to be completed

Order to proceed...

* dynamic applier
* permit rule applier
* permit-filter (ok)
* allower
* ability
* authorizer

* rule matches (see below)
* rules parser
* rules loading

### Rule match

Should avoid intersect, fun etc: Simply imply via type (Object or Function). 

```
matches:

# OLD STYLE
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
            
```            
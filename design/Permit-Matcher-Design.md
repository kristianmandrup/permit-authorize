# Permit Matcher Design

A Permit matcher has the *Single Responsibiity* to match a given `AccessRequest` on a `Permit` (context) in order to determine
if the context is valid for that `AccessRequest` and should be taken into account.

### Context Matcher

`ContextMatcher` is used determines if a `Permit` (context) should be included or excluded from the current authorization session.
The `ContextMatcher` can be used to make *inclusion* and *exclusion* tests, taking a `context` and `key` to form the `matchContext`.   

If the key is: 

`Object` - intersection test is done with the `AccessRequest`.
`Function` - function is called with the `AccessRequest`. 

Note: The function will be run in a special `MatchingContext` context, which has access to various matching 
helpers that delegate to an `AccessMatcher`.
 
### CompiledMatcher

The `CompiledMatcher` is a matcher which precompiles a `matchesOn` object into an include or exclude function.


```LiveScript

matches:
    intersect:
        includes:
            user:
                role: 'admin'
         
        excludes:
            user:
                name: 'My evil twin'
            
    compile:
        includes:
            roles: ['publisher', 'editor']
        excludes:
            subject: 'Article'
        
    fun:
        includes: ->
            @matching!.actions ['read', 'write']
```

            
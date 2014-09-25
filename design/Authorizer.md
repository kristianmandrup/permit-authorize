# Authorizer

Wraps an `Ability` which auto-populates the AccessRequest with a user (current session user).

Simply a facade which enables a different (and more flexible) interface.

TODO:

`authorize: (action, subjec, ctx)`

Instead use ...args pass to Ability which performs argument normalization to create an AccessRequest.

```
authorize: (...args) ->
  @can ...args
```

It should be a basic wrapper, delegater and allow exchanging the ability class used from `Ability` to `CachedAbility`.
The user should use the `Authorizer` as the main entry point!
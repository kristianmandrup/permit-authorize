# Ability

A facade for an `Allower`. It also wraps a User object to ensure that the `AccessRequest` 
is always populated with a user, typically the current (session) user.

It populates the `AccessRequest` object with the user and then asks the `Allower` if it will grant access.
 
# Cached Ability

A wrapper for Ability which caches the access result for each `AccessRequest` by taking a fingerprint. This means, that
the next time the ability is asked for access, it can respond immediately (unless the cache has been cleared in the meantime).

The cache will (should!) be cleared whenever a permit is changed or a permit is added or removed.
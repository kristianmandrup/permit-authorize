# Dynamic Applier

Applies dynamic rules for a permit given a specific Access Request. Only those uncompiled rules in the DSL which match the
access request are compiled and added to the dynamic rule repo.

On every request, the dynamic rule repo needs to be cleared so that old rules (from old requests) don't take part for new requests!

Every rule is applied in an `ExecutionContext`
# Architecture Overview

## The main parts

### Permit

A permit is loaded (and generated) from a DSL. The `PermitDsLParser` is pluggable.

Permit matching can be enabled on Permit via. `Permit.enable-matching!` otherwise matching is disabled
and all permits match automatically. If you still want to control which permits are considered without matching,
simply group permits into `PermitContainers`.

The `RuleRepo` is a container for rules. It can register a rule, clear the repo and match a rule on all the rules in the repo
 to see if there is a match (and the permit thus allows access).
Each of these can be customized as you see fit.

### Flexibility

You can add anything which has a `match` function on an Ability, such as a `RuleRepo`  a `Permit` or a `PermitFilter`.
You can even add a custom `match function that just tests if user.role is admin or not, *CanCan* style :P.
 
 or even

```
class Ability 
    match (ar) ->
        return new MatchContext(@repo, @rules).match!
    
    rules: ->
        @ucan 'edit', 'Book'
```        
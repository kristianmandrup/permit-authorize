# Allower

Guards the permits from access. It first uses a `PermitFilter` to filter which permits should be considered for the 
current access test. The filtered permits are then iterated and each one is asked if it *allows* or *disallows* access by the
access request. Returns when the first permit answers affirmative (true/yes).

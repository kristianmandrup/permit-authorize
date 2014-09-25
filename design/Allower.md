# Allower

Guards the active permits from access by the access request. 
It first uses a `PermitFilter` to filter which permits should be considered for the 
current access test. The filtered permits are then iterated. Each permit is asked if it *allows* or *disallows* access by the
access request (by rule matching). Returns when the first permit answers affirmative (true/yes).

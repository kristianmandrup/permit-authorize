# Permit Container

A container for permits that allows them to be categorized in whatever "dimensions" you like.
One could group permits by environment, security domain (user, guest, admin) or whatever.
You can control which containers are active or inactive. Only active containers are considered
by the `PermitFilter`. If no containers have any permits, all permits are considered active.
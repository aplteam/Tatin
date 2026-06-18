---
title: "About hosting"
description: "Host a personal, team, corporate or public Tatin registry"
<!-- keywords: "host, registry, server" -->
---
# Host a Tatin registry

!!! abstract "Host a personal, team, corporate, or public Tatin registry."


You can host a Tatin registry server on your local machine, an intranet, or on a public server.


## Requirements

-   Dyalog Unicode 18.2+
-   Linux or Windows

The server should run under macOS in a Docker container, but this has not been tested.


## Plodder

Tatin uses [Plodder](https://github.com/aplteam/Plodder) as an HTTP/S server.
Tatin's server is configured via a Plodder INI file extended with Tatin-specific settings — it is the primary means of controlling the server's behaviour.
See [Install a server](install-server.md) for details.

